//
//  MockConnection.swift
//  PGNetworking
//
//  Created by Goran Pavlovic on 01/11/2020.
//

import Foundation

struct MockConnection: NetworkReachability {
    let isNetConnected: Bool
    let isOnCelular: Bool
    let isOnWiFi: Bool
}
