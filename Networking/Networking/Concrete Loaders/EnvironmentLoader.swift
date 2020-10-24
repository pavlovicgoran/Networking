//
//  EnvironmentLoader.swift
//  Networking
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import Foundation

public class EnvironmentLoader: HTTPLoader {
    private let environment: ServerEnvironment
    
    public init(environment: ServerEnvironment) {
        self.environment = environment
        super.init()
    }
    
    public override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        var requestCopy = request
        if requestCopy.host?.isEmpty ?? true {
            requestCopy.host = environment.host
        }
        let isPathPrefixed = requestCopy.path.hasPrefix("/")
        let pathJoiner = isPathPrefixed ? "" : "/"
        requestCopy.path = environment.pathPrefix + pathJoiner + requestCopy.path
        
        for (header, value) in environment.headers {
            requestCopy.headers[header] = value
        }
        
        super.load(request: requestCopy, completion: completion)
    }
}
