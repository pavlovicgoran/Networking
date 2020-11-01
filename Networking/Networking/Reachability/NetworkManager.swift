//
//  NetworkManager.swift
//  PGNetworking
//
//  Created by Goran Pavlovic on 01/11/2020.
//

import Foundation

public enum NetworkStatus {
    case noInternet
    case wifi
    case cellular
    case unknown
}

public class NetworkManager: NetworkReachability {
    public static let shared = NetworkManager()
    private var reachability: Reachability?
    
    public var networkStatus: NetworkStatus {
        guard let reachability = reachability else {
            return .unknown
        }
        switch reachability.connection {
            case .cellular:
                return .cellular
            case .wifi:
                return .wifi
            case .unavailable:
                return .noInternet
        }
    }
    
    public var isNetConnected: Bool {
        return networkStatus != .noInternet
    }
    
    public var isOnCelular: Bool {
        return networkStatus == .cellular
    }
    
    public var isOnWiFi: Bool {
        return networkStatus == .wifi
    }
    
    private init() {
        reachability = try? Reachability(hostname: "google.com")
        try? reachability?.startNotifier()
    }
    
    deinit {
        reachability?.stopNotifier()
    }}
