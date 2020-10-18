//
//  HTTPResponse.swift
//  Networking
//
//  Created by Goran Pavlovic on 18/10/2020.
//

import Foundation

public struct HTTPResponse {
    public let request: HTTPRequest
    private let response: HTTPURLResponse
    public let body: Data?
}

public extension HTTPResponse {
    var status: HTTPStatus {
        return HTTPStatus(statusCode: response.statusCode)
    }
    
    var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }
    
    var headers: [AnyHashable: Any] { response.allHeaderFields }
}
