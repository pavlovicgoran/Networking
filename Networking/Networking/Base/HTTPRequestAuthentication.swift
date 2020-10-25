//
//  HTTPRequestAuthentication.swift
//  Networking
//
//  Created by Goran Pavlovic on 25/10/2020.
//

import Foundation

public extension HTTPRequest {
    enum AuthenticationMethod {
        case oath2
        case apiKey
        case none
    }
}
