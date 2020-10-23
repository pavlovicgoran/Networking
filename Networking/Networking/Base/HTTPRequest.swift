//
//  HTTPRequest.swift
//  Networking
//
//  Created by Goran Pavlovic on 18/10/2020.
//

import Foundation

public struct HTTPRequest {
    private enum Constants {
        static let https = "https"
    }
    private var urlComponents = URLComponents()
    
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:]
    public var body: HTTPBody = EmptyBody()
    
    public init() {
        urlComponents.scheme = Constants.https
    }
}

public extension HTTPRequest {
    var scheme: String {
        get { urlComponents.scheme ?? Constants.https }
        set { urlComponents.scheme = newValue }
    }
    
    var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }
    
    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
    
    var url: URL? {
        urlComponents.url
    }
}
