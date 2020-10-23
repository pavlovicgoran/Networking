//
//  HTTPResult.swift
//  Networking
//
//  Created by Goran Pavlovic on 18/10/2020.
//

import Foundation

public typealias HTTPResult = Result <HTTPResponse, HTTPError>

public struct HTTPError: Error {
    // The high-level classification of this error
    public let code: Code
    
    // The HTTPRequest that resulted in this error
    public let request: HTTPRequest
    
    // Any HTTPResponse (partial or otherwise) that we have
    public let response: HTTPResponse?
    
    // More information about error that caused it
    public let underlyingError: Error?
    
    public enum Code {
        case invalidRequest     // the HTTPRequest could not be turned into a URLRequest
        case cannotConnect      // some sort of connectivity problem
        case cancelled          // the user cancelled the request
        case insecureConnection // couldn't establish a secure connection to the server
        case invalidResponse    // the system did not receive a valid HTTP response
        case couldntBuildUrl    // the url couldn't be constructed
        case invalidBodySerialization   // the HTTPBody couldn't be serialized
        case unknown            // we have no idea what the problem is
    }
}

public extension HTTPResult {
    
    var request: HTTPRequest {
        switch self {
            case .success(let response):
                return response.request
            case .failure(let error):
                return error.request
        }
    }
    
    var response: HTTPResponse? {
        switch self {
            case .success(let response):
                return response
            case .failure(let error):
                return error.response
        }
    }
}
