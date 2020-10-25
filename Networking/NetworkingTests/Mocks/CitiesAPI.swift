//
//  CitiesAPI.swift
//  NetworkingTests
//
//  Created by Goran Pavlovic on 25/10/2020.
//

import Foundation
@testable import Networking

// Mock class to test RetryingLoader Logic
public class CitiesAPI {
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func requestCity(with id: Int, completion: @escaping (Result<City, HTTPError>) -> Void) {
        var request = HTTPRequest()
        request.path = "city/\(id)"
        
        loader.load(request: request) {result in
            
            switch result {
                case .success(let response):
                    guard let data = response.body else {
                        let error = HTTPError(code: .noData, request: request)
                        completion(.failure(error))
                        return
                    }
                    
                    guard let city = try? JSONDecoder().decode(City.self, from: data) else {
                        let error = HTTPError(code: .invalidBodyDeserialization, request: request)
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(city))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

public struct City: Codable {
    public let name: String
}
