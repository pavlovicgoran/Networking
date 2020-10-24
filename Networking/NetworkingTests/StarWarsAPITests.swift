//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Goran Pavlovic on 23/10/2020.
//

import XCTest
@testable import Networking

class StarWarsAPITests: XCTestCase {
    let mock = MockLoader()
    lazy var api: StarWarsAPI = {
        return StarWarsAPI(loader: mock)
    }()
    
    // Tests 200 Valid JSON
    func test200ValidJSON() {
        mock.then { request, handler in
            let urlResponse = HTTPURLResponse()
            let data = Character(name: "Luke Skywalker")
            let body = try? JSONEncoder().encode(data)
            let response = HTTPResponse(request: request, response: urlResponse, body: body)
            handler(.success(response))
        }
        
        api.requestPeople { result in
            switch result {
                case .success(let character):
                    XCTAssertEqual(character.name, "Luke Skywalker")
                case .failure(let error):
                    XCTFail("The test 200ValidJSON failed with error \(error)")
            }
        }
    }
    
    // Tests 200 no body returned
    func test200NoBody() {
        mock.then { request, handler in
            let urlResponse = HTTPURLResponse()
            let response = HTTPResponse(request: request, response: urlResponse, body: nil)
            handler(.success(response))
        }
        
        api.requestPeople { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error.code, .noData)
            } else {
                XCTFail("This is a test for `failure` case error")
            }
        }
    }
    
    func test404Eror() {
        mock.then { request, handler in
            let urlResponse = HTTPURLResponse(url: request.url!, statusCode: HTTPStatus.notFound.statusCode, httpVersion: "1.1", headerFields: nil)!
            let response = HTTPResponse(request: request, response: urlResponse, body: nil)
            handler(.success(response))
        }
        
        api.requestPeople { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error.code, .notFound)
            } else {
                XCTFail("This is a test for `failure` case error")
            }
        }
    }
    
    func test501Error() {
        mock.then { request, handler in
            let urlResponse = HTTPURLResponse(url: request.url!, statusCode: HTTPStatus.internalServerError.statusCode, httpVersion: "1.1", headerFields: nil)!
            let response = HTTPResponse(request: request, response: urlResponse, body: nil)
            handler(.success(response))
        }
        
        api.requestPeople { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error.code, .internalServerError)
            } else {
                XCTFail("This is a test for `failure` case error")
            }
        }
    }
}
