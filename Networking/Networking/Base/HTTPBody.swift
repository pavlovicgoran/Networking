//
//  HTTPBody.swift
//  Networking
//
//  Created by Goran Pavlovic on 18/10/2020.
//

import Foundation

public protocol HTTPBody {
    var isEmpty: Bool { get }
    var additionalHeaders: [String: String] { get }
    func encode() throws -> Data
}

public extension HTTPBody {
    var isEmpty: Bool { return false }
    var additionalHeaders: [String: String] { return [:] }
}

public struct EmptyBody: HTTPBody {
    public let isEmpty = true
    
    public init() {}
    public func encode() throws -> Data {
        return Data()
    }
}

public struct DataBody: HTTPBody {
    private let data: Data
    
    public var isEmpty: Bool { return data.isEmpty }
    public var additionalHeaders: [String : String]
    
    public init(_ data: Data, additionalHeaders: [String: String] = [:]) {
        self.data = data
        self.additionalHeaders = additionalHeaders
    }
    
    public func encode() throws -> Data { return data }
}

public struct JSONBody: HTTPBody {
    public let isEmpty: Bool = false
    public var additionalHeaders = [
        "Content-Type": "application/json; charset=utf-8"
    ]
    
    private let encodingClosure: () throws -> Data
    
    public init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        self.encodingClosure = { try encoder.encode(value) }
    }
    
    public func encode() throws -> Data {
        return try encodingClosure()
    }
}

public struct FormBody: HTTPBody {
    public var isEmpty: Bool { values.isEmpty }
    public let additionalHeaders = [
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    ]
    
    private let values: [URLQueryItem]
    
    public init(_ values: [URLQueryItem]) {
        self.values = values
    }
    
    public init(_ values: [String: String]) {
        let queryItems = values.map { URLQueryItem(name: $0.key, value: $0.value) }
        self.init(queryItems)
    }
    
    public func encode() throws -> Data {
        let pieces = values.map { self.urlEncode($0) }
        let bodyString = pieces.joined(separator: "&")
        return Data(bodyString.utf8)
    }
    
    private func urlEncode(_ queryItem: URLQueryItem) -> String {
        let name = urlEncode(queryItem.name)
        let value = urlEncode(queryItem.value ?? "")
        return "\(name)=\(value)"
    }
    
    private func urlEncode(_ string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
}
