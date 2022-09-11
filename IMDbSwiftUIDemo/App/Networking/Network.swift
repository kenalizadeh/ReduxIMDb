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

    var parameters: Parameters {
        switch self {
        case .custom(let parameters):
            return parameters
        }
    }
}

class BaseNetworkService<RequestDTO: RequestDTOProtocol, ResponseDTO: ResponseDTOProtocol>: ObservableObject {
    private var _baseURL: URL { NetworkConstants.baseURL }

    private var _url: URL {
        _baseURL.appendingPathComponent(path)
    }

    private var _cancellable: Cancellable?

    private var _headerParameters: Parameters {
        httpHeaders.compactMap { $0.parameters }.reduce([:]) { partialResult, params in
            partialResult.merging(params, uniquingKeysWith: { (_, params) in params })
        }
    }

    var path: String { "" }

    var successStatusCodes: [Int] = [200, 201, 204]

    var httpMethod: HTTPMethod { .get }

    var httpHeaders: [HTTPHeader] { [] }

    @Published
    var responseDTO: ResponseDTO?

    @Published
    var error: Error?

    @Published
    var isSuccess: Bool = false

    @Published
    var hasError: Bool = false

    @Published
    var isLoading: Bool = false

    func makePublisher(with params: RequestDTO? = nil) -> AnyPublisher<ResponseDTO, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: makeRequest(with: params))
            .tryMap { (data: Data, response: URLResponse) -> ResponseDTO in
                // Check response status code
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    self.successStatusCodes.contains(httpResponse.statusCode)
                else { throw URLError(.badServerResponse) }

                #if DEBUG
                print(":LOG: \(type(of: ResponseDTO.self)) START")
                if let jsonString = try data.json() {
                    print(":LOG:", jsonString)
                } else {
                    print(":LOG: Data could not be parsed as a valid JSON")
                }
                print(":LOG: \(type(of: ResponseDTO.self)) END")
                #endif

                // Check data
                let decoded = try JSONDecoder().decode(ResponseDTO.self, from: data)
                self.processData(decoded)
                return decoded
            }
            #if DEBUG
            .mapError {
                print(":LOG: NetworkError: \(ResponseDTO.self)", $0)
                return $0
            }
            #endif
            .eraseToAnyPublisher()
    }

    func send(_ params: RequestDTO? = nil) {
        _cancellable?.cancel()
        isLoading = true

        _cancellable = makePublisher(with: params)
            .receive(on: DispatchQueue.main)
            .sink { result in
                self.isLoading = false

                if case let .failure(error) = result {
                    self.error = error
                }
            } receiveValue: { data in
                self.isLoading = false

                self.responseDTO = data
                self.isSuccess = true
            }
    }

    func makeRequest(with params: RequestDTO?) -> URLRequest {
        var urlRequest: URLRequest

        switch self.httpMethod {
        case .get:
            var urlComponents = URLComponents(url: _url, resolvingAgainstBaseURL: false)!
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

            for header in _headerParameters {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        case .post:
            urlRequest = URLRequest(
                url: _url,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 30
            )

            let dtoAsJson = try! JSONEncoder().encode(params)

            urlRequest.httpBody = dtoAsJson
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            for header in _headerParameters {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        urlRequest.httpMethod = httpMethod.rawValue

        return urlRequest
    }

    func cancel() {
        _cancellable?.cancel()
        isLoading = false
    }

    func processData(_ data: ResponseDTO) {}
}
