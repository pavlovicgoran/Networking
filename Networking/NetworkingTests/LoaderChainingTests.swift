//
//  LoaderChainingTests.swift
//  NetworkingTests
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import XCTest
@testable import Networking

public class TestLoader: HTTPLoader {}

public class LoaderChainingTests: XCTestCase {
    let mock = MockLoader()
    lazy var api: StarWarsAPI = {
        let testLoader = TestLoader()
        testLoader --> mock
        return StarWarsAPI(loader: testLoader)
    }()
    
    func testLoaderChaining() {
        mock.then { request, handler in
            XCTAssertEqual(request.path, StarWarsAPI.Constants.peoplePath)
            let urlResponse = HTTPURLResponse()
            let data = Character(name: "Chewbacka")
            let body = try? JSONEncoder().encode(data)
            let response = HTTPResponse(request: request, response: urlResponse, body: body)
            handler(.success(response))
        }
        
        api.requestPeople { result in
            if case let .success(character) = result {
                XCTAssertEqual(character.name, "Chewbacka")
            } else {
                XCTFail("This is a test for Loader Chaining Successful case")
            }
        }
    }
}
