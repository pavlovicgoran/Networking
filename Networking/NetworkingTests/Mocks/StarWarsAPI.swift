//
//  StarWarsAPI.swift
//  NetworkingTests
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import Foundation
@testable import PGNetworking

extension ServerEnvironment {
    static let production = ServerEnvironment(host: StarWarsAPI.Constants.host, pathPrefix: StarWarsAPI.Constants.apiPrefix)
}

public class StarWarsAPI {
    enum Constants {
        static let host = "swapi.dev"
        static let apiPrefix = "/api"
        static let apiKey = "api_key"
    }
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        let productionLoader = EnvironmentLoader(environment: .production)
        
        let authenticator = AuthenticationLoader { request in
            var requestCopy = request
            switch request.authenticationMethod {
                case .apiKey:
                    let item = URLQueryItem(name: Constants.apiKey, value: "SUPER_SECRET")
                    requestCopy.queryItems = [item]
                    return requestCopy
                default:
                    return request
            }
        }
        let composite = productionLoader --> authenticator --> loader
        self.loader = composite ?? loader
    }
    
    public func requestPeople(completion: @escaping (Result<Character, HTTPError>) -> Void) {
        var request = HTTPRequest()
        request.path = "people"
        request.authenticationMethod = .apiKey
        
        loader.load(request: request) { result in
            switch result {
                case .success(let response):
                    switch response.status {
                        case .ok:
                            // Check if there is data
                            guard let body = response.body else {
                                let error = HTTPError(code: .noData, request: request, response: response, underlyingError: nil)
                                completion(.failure(error))
                                return
                            }
                            // Deserialize Character
                            guard let character = try? JSONDecoder().decode(Character.self, from: body) else {
                                let error = HTTPError(code: .invalidBodyDeserialization, request: request, response: response)
                                completion(.failure(error))
                                return
                            }
                            completion(.success(character))
                            
                        case .badRequest:
                            let error = HTTPError(code: .badRequest, request: request, response: response)
                            completion(.failure(error))
                            
                        case .notFound:
                            let error = HTTPError(code: .notFound, request: request, response: response)
                            completion(.failure(error))
                            
                        case .internalServerError:
                            let error = HTTPError(code: .internalServerError, request: request, response: response)
                            completion(.failure(error))
                            
                        default:
                            let error = HTTPError(code: .unknown, request: request, response: response, underlyingError: nil)
                            completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

public struct Character: Codable {
    public let name: String
}
