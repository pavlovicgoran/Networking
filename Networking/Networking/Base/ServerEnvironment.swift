//
//  ServerEnvironment.swift
//  Networking
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import Foundation

public struct ServerEnvironment {
    public var host: String
    public var pathPrefix: String
    public var headers: [String: String]
    public var query: [URLQueryItem]
    
    public init(host: String, pathPrefix: String = "/", headers: [String: String] = [:], query: [URLQueryItem] = []) {
        let prefix = pathPrefix.hasPrefix("/") ? "" : "/"
        
        self.host = host
        self.pathPrefix = prefix + pathPrefix
        self.headers = headers
        self.query = query
    }
}
