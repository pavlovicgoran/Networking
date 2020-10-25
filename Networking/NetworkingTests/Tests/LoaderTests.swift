//
//  LoaderChainingTests.swift
//  NetworkingTests
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import XCTest
@testable import Networking

public class LoaderChainingTests: XCTestCase {
    let mock = MockLoader()
    lazy var api: StarWarsAPI = {
        return StarWarsAPI(loader: mock)
    }()
    let retryCondition: RetryingCondition = { result in
        switch result {
            case .success:
                return false
            case .failure:
                return true
        }
    }
    
    func testAuthenticationLoader() {
        mock.then { request, handler in
            let queryItems = request.queryItems
            let authenticationItem = URLQueryItem(name: StarWarsAPI.Constants.apiKey, value: "SUPER_SECRET")
            XCTAssertTrue(queryItems?.contains(authenticationItem) ?? false)
        }
        api.requestPeople { _ in }
    }
    
    func testRetryLoaderSuccess() {
        // Loader Setup
        let retryLoader = RetryingLoader(maxRetryingCount: 3, retryingDelay: 0.2, retryingCondition: retryCondition)
        let loader = retryLoader --> mock ?? mock
        let api = CitiesAPI(loader: loader)
        
        // Test Setup
        let expectation = XCTestExpectation(description: "Test Retry Loader that should retry 3 times and should return success on the last execution")
        for i in 1...3 {
            mock.then { request, handler in
                if i != 3 {
                    let error = HTTPError(code: .badRequest, request: request)
                    handler(.failure(error))
                } else {
                    let urlResponse = HTTPURLResponse()
                    let city = City(name: "Belgrade")
                    let body = try? JSONEncoder().encode(city)
                    let response = HTTPResponse(request: request, response: urlResponse, body: body)
                    handler(.success(response))
                }
            }
        }
        
        api.requestCity(with: 22) { cityResult in
            if case let .success(city) = cityResult {
                XCTAssertEqual(city.name, "Belgrade")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testRetryLoaderExceeded() {
        // Loader Setup
        let retryLoader = RetryingLoader(maxRetryingCount: 3, retryingDelay: 0.2, retryingCondition: retryCondition)
        let loader = retryLoader --> mock ?? mock
        let api = CitiesAPI(loader: loader)
        
        // Test Setup
        let expectation = XCTestExpectation(description: "Test Retry Loader that should retry 3 times and should return success on the last execution")
        for _ in 1...4 {
            mock.then { request, handler in
                let error = HTTPError(code: .badRequest, request: request)
                handler(.failure(error))
            }
        }
        
        api.requestCity(with: 22) { cityResult in
            if case let .failure(error) = cityResult {
                if error.code != .badRequest {
                    XCTAssertEqual(error.code, .retryCountExceeded)
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
