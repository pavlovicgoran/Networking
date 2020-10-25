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
    
    func testAuthenticationLoader() {
        mock.then { request, handler in
            let queryItems = request.queryItems
            let authenticationItem = URLQueryItem(name: StarWarsAPI.Constants.apiKey, value: "SUPER_SECRET")
            XCTAssertTrue(queryItems?.contains(authenticationItem) ?? false)
        }
        api.requestPeople { _ in }
    }
}
