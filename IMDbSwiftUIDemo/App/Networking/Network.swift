//
//  Network.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias Parameters = [String: String]

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
}

struct NetworkConstants {
    static let baseURL = URL(string: "https://imdb-api.com/en/API/")!
    static let apiToken: String = "k_wvico135"
    static let accessTokenStorageKey: String = "NCAccessToken"
    static let refreshTokenStorageKey: String = "NCRefreshToken"
}

enum HTTPHeader {
    case custom(Parameters)
    case authorization
    case refresh

    var parameters: Parameters {
        switch self {
        case .custom(let parameters):
            return parameters

        case .authorization:
            return ["Authorization": "Bearer \(Storage.shared.accessToken ?? "")"]

        case .refresh:
            return ["Authorization": "Bearer \(Storage.shared.refreshToken ?? "")"]
        }
    }
}

class BaseNetworkService<RequestDTO: RequestDTOProtocol, ResponseDTO: ResponseDTOProtocol>: ObservableObject {
    var baseURL: URL { NetworkConstants.baseURL }
    var path: String { "" }
    var cancellable: Cancellable?

    var url: URL {
        baseURL.appendingPathComponent(path)
    }

    var successStatusCodes: [Int] = [200, 201, 204]

    var httpMethod: HTTPMethod { .get }

    var httpHeaders: [HTTPHeader] { [] }

    @Published
    var responseDTO: ResponseDTO?

    private var headerParameters: Parameters {
        httpHeaders.compactMap { $0.parameters }.reduce([:]) { partialResult, params in
            partialResult.merging(params, uniquingKeysWith: { (_, params) in params })
        }
    }

    @Published
    var error: Error?

    @Published
    var isSuccess: Bool = false

    @Published
    var hasError: Bool = false

    func makePublisher(with params: RequestDTO?) -> AnyPublisher<ResponseDTO, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: makeRequest(with: params))
            .receive(on: DispatchQueue.main)
            .tryMap { (data: Data, response: URLResponse) -> ResponseDTO in
                // Check response status code
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    self.successStatusCodes.contains(httpResponse.statusCode)
                else { throw URLError(.badServerResponse) }

                // Check data
                let decoded = try JSONDecoder().decode(ResponseDTO.self, from: data)
                self.processData(decoded)
                return decoded
            }
            .eraseToAnyPublisher()
    }

    func send(_ params: RequestDTO? = nil) {
        cancellable = makePublisher(with: params)
            .sink { result in
                if case let .failure(error) = result {
                    self.error = error
                }
            } receiveValue: { data in
                self.responseDTO = data
                self.isSuccess = true
            }
    }

    func makeRequest(with params: RequestDTO?) -> URLRequest {
        var urlRequest: URLRequest

        switch self.httpMethod {
        case .get:
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = []

            let dataDict = params.asDictionary()

            for (key, value) in dataDict {
                let queryItem = URLQueryItem(
                    name: key,
                    value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                )
                urlComponents.queryItems?.append(queryItem)
            }

            urlRequest = URLRequest(
                url: urlComponents.url!,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 30
            )

            urlRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            for header in headerParameters {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        case .post:
            urlRequest = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 30
            )

            let dtoAsJson = try! JSONEncoder().encode(params)

            urlRequest.httpBody = dtoAsJson
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            for header in headerParameters {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        urlRequest.httpMethod = httpMethod.rawValue

        return urlRequest
    }

    func processData(_ data: ResponseDTO) {}
}
