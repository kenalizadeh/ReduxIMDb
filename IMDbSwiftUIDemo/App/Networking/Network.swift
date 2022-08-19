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
}

enum HTTPHeaders {
    case custom(Parameters)
//    case authorization
//    case refresh

    var parameters: Parameters {
        switch self {
        case .custom(let parameters):
            return parameters

//        case .authorization:
//            return ["Authorization": "Bearer \(Storage.shared.accessToken ?? "")"]
//
//        case .refresh:
//            return ["Authorization": "Bearer \(Storage.shared.refreshToken ?? "")"]
        }
    }
}

class BaseNetworkService<RequestDTO: RequestDTOProtocol, ResponseDTO: ResponseDTOProtocol>: ObservableObject {
    let backgroundQueue = DispatchQueue(label: "NetworkService.Queue", qos: .userInitiated)

    var baseURL: URL { NetworkConstants.baseURL }
    var path: String { "" }
    var cancellable: Cancellable?

    var url: URL {
        baseURL.appendingPathComponent(path)
    }

    var httpMethod: HTTPMethod { .get }

    @Published
    var responseDTO: ResponseDTO?

    var delay: Double { 0 }

    var headers: [HTTPHeaders] { [] }

    private var headerParameters: Parameters {
        headers.compactMap { $0.parameters }.reduce([:]) { partialResult, params in
            partialResult.merging(params, uniquingKeysWith: { (_, params) in params })
        }
    }

    @Published
    var error: Error? {
        didSet {
            hasError = error != nil
        }
    }

    @Published
    var isSuccess: Bool = false

    @Published
    var hasError: Bool = false

    func makeRequest(with params: RequestDTO?) -> URLRequest {
        switch self.httpMethod {
        case .get:
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = []

            let dataDict = params.asDictionary()

            for (key,value) in dataDict {
                let queryItem = URLQueryItem(
                    name: key,
                    value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                )
                urlComponents.queryItems?.append(queryItem)
            }

            var urlRequest = URLRequest(
                url: urlComponents.url!,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 30
            )

            urlRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            for header in headerParameters {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }

            return urlRequest
        case .post:
            var urlRequest = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 30
            )

            let dtoAsJson = try! JSONEncoder().encode(params)

            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = dtoAsJson
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            for header in headerParameters {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }

            return urlRequest
        }
    }

    func fetch(_ params: RequestDTO? = nil) {
        let urlRequest = self.makeRequest(with: params)

        let task = URLSession(configuration: .default)
            .dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print(":LOG:", Self.self, "Error", error)
                    DispatchQueue.main.async {
                        self.error = error
                    }
                    return
                }

                guard
                    let httpResponse = response as? HTTPURLResponse,
                    [200, 201, 204].contains(httpResponse.statusCode)
                else {
                    let error = URLError(.badServerResponse)
                    print(":LOG:", Self.self, "Error", error)
                    DispatchQueue.main.async {
                        self.error = error
                    }
                    return
                }

                guard let data = data else {
                    let error = URLError(.badServerResponse)
                    print(":LOG:", Self.self, "Error", error)
                    DispatchQueue.main.async {
                        self.error = error
                    }
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ResponseDTO.self, from: data)
                    print(":LOG:", Self.self, "Data", decoded)
                    DispatchQueue.main.async {
                        self.processData(decoded)
                        self.responseDTO = decoded
                        self.isSuccess = true
                    }
                } catch(let error) {
                    print(":LOG:", Self.self, "Error", error)
                    DispatchQueue.main.async {
                        self.error = error
                    }
                }
            }

        backgroundQueue.asyncAfter(deadline: .now() + delay) {
            task.resume()
        }
    }

    func processData(_ data: ResponseDTO) {}
}
