//
//  StarWarsAPI.swift
//  NetworkingTests
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import Foundation
@testable import Networking

public class StarWarsAPI {
    enum Constants {
        static let host = "swapi.dev"
        static let apiPath = "/api/"
    }
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        let modifier = ModifyRequestLoader { request in
            var requestCopy = request
            if requestCopy.host?.isEmpty ?? true {
                requestCopy.host = Constants.host
            }
            if !requestCopy.path.hasPrefix("/") {
                requestCopy.path = Constants.apiPath + requestCopy.path
            }
            return requestCopy
        }
        
        self.loader = modifier --> loader ?? loader
    }
    
    public func requestPeople(completion: @escaping (Result<Character, HTTPError>) -> Void) {
        var request = HTTPRequest()
        request.host = "people"
        
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
