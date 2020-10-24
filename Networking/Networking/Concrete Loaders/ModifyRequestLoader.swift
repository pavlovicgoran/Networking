//
//  ModifyRequestLoader.swift
//  Networking
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import Foundation

public typealias ModifyRequest = (HTTPRequest) -> HTTPRequest

public class ModifyRequestLoader: HTTPLoader {
    private let modify: ModifyRequest
    
    public init(modify: @escaping ModifyRequest) {
        self.modify = modify
        super.init()
    }
    
    public override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        let modifiedRequest = modify(request)
        super.load(request: modifiedRequest, completion: completion)
    }
}
