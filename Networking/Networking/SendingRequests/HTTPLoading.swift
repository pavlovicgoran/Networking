//
//  HTTPLoading.swift
//  Networking
//
//  Created by Goran Pavlovic on 23/10/2020.
//

import Foundation

public protocol HTTPLoading {
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
}
