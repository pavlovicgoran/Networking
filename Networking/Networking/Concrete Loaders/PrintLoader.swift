//
//  PrintLoader.swift
//  Networking
//
//  Created by Goran Pavlovic on 24/10/2020.
//

import Foundation

public class PrintLoader: HTTPLoader {
    public override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        print("Loading \(request)")
        super.load(request: request) { result in
            print("Got result: \(result)")
            completion(result)
        }
    }
}
