//
//  HTTPStatus.swift
//  Networking
//
//  Created by Goran Pavlovic on 18/10/2020.
//

import Foundation

public struct HTTPStatus {
    private let statusCode: Int
    
    public init (statusCode: Int) {
        self.statusCode = statusCode
    }
}
