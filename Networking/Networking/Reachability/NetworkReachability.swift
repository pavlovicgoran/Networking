//
//  NetworkReachability.swift
//  PGNetworking
//
//  Created by Goran Pavlovic on 01/11/2020.
//

import Foundation

public protocol NetworkReachability {
    var isNetConnected: Bool { get }
    var isOnCelular: Bool { get }
    var isOnWiFi: Bool { get }
}
