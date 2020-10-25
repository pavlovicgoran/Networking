//
//  AuthenticationLoader.swift
//  Networking
//
//  Created by Goran Pavlovic on 25/10/2020.
//

import Foundation

public typealias AuthenticateRequest = (HTTPRequest) -> HTTPRequest

public class AuthenticationLoader: HTTPLoader {
    private let authenticate: AuthenticateRequest
    
    public init(authenticate: @escaping AuthenticateRequest) {
        self.authenticate = authenticate
        super.init()
    }
    
    public override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        let authenticatedRequest = authenticate(request)
        super.load(request: authenticatedRequest, completion: completion)
    }
}
