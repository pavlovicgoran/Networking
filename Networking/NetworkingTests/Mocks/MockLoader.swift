//
//  MockLoader.swift
//  NetworkingTests
//
//  Created by Goran Pavlovic on 23/10/2020.
//

import Foundation
@testable import PGNetworking

public class MockLoader: HTTPLoader {
    public typealias HTTPHandler = (HTTPResult) -> Void
    public typealias MockHandler = (HTTPRequest, HTTPHandler) -> Void
    
    private var nextHandlers = [MockHandler]()
    
    public override func load(request: HTTPRequest, completion: @escaping HTTPHandler) {
        if nextHandlers.isEmpty == false {
            let next = nextHandlers.removeFirst()
            next(request, completion)
        } else {
            let error = HTTPError(code: .cannotConnect, request: request, response: nil, underlyingError: nil)
            completion(.failure(error))
        }
    }
    
    @discardableResult
    public func then(_ handler: @escaping MockHandler) -> MockLoader {
        nextHandlers.append(handler)
        return self
    }
}
