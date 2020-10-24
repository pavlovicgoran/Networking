//
//  HTTPStatus.swift
//  Networking
//
//  Created by Goran Pavlovic on 18/10/2020.
//

import Foundation

public struct HTTPStatus: Equatable {
    public let statusCode: Int
    
    public init (statusCode: Int) {
        self.statusCode = statusCode
    }
}

public extension HTTPStatus {
    static let ok = HTTPStatus(statusCode: 200)
    static let created = HTTPStatus(statusCode: 201)
    static let accepted = HTTPStatus(statusCode: 202)
    static let nonAuthoritativeInformation = HTTPStatus(statusCode: 203)
    static let noContent = HTTPStatus(statusCode: 204)
    
    static let badRequest = HTTPStatus(statusCode: 400)
    static let unathorized = HTTPStatus(statusCode: 401)
    static let forbidden = HTTPStatus(statusCode: 403)
    static let notFound = HTTPStatus(statusCode: 404)
    
    static let internalServerError = HTTPStatus(statusCode: 500)
    static let serviceUnavailable = HTTPStatus(statusCode: 503)
}
