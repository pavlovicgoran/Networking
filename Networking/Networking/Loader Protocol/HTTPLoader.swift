//
//  HTTPLoader.swift
//  Networking
//
//  Created by Goran Pavlovic on 23/10/2020.
//

import Foundation

open class HTTPLoader {
    public var nextLoader: HTTPLoader? {
        willSet {
            guard nextLoader == nil else {
                assertionFailure("The nextLoader can only be set once")
                return
            }
        }
    }
    
    public init() { }
    
    open func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        if let nextLoader = nextLoader {
            nextLoader.load(request: request, completion: completion)
        } else {
            let error = HTTPError(code: .cannotConnect, request: request)
            completion(.failure(error))
        }
    }
}
