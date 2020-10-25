//
//  RetryingLoader.swift
//  Networking
//
//  Created by Goran Pavlovic on 25/10/2020.
//

import Foundation

// If true the load request will be retried
public typealias RetryingCondition = (HTTPResult) -> Bool

public class RetryingLoader: HTTPLoader {
    public enum Constants {
        public static let defaultRetryingCount = 3
        public static let defaultRetryingDelay: TimeInterval = 2
    }
    private let maxRetryingCount: Int
    private let retryingDelay: TimeInterval
    private let retryingCondition: RetryingCondition
    private var counter = 0
    
    public init(
        maxRetryingCount: Int = Constants.defaultRetryingCount,
        retryingDelay: TimeInterval = Constants.defaultRetryingDelay,
        retryingCondition: @escaping RetryingCondition
    ) {
        self.maxRetryingCount = maxRetryingCount
        self.retryingDelay = retryingDelay
        self.retryingCondition = retryingCondition
        super.init()
    }
    
    public override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        guard counter <= maxRetryingCount else {
            let error = HTTPError(code: .retryCountExceeded, request: request)
            completion(.failure(error))
            return
        }
        
        super.load(request: request) { [weak self] result in
            guard self?.retryingCondition(result) ?? false else {
                completion(result)
                return
            }
            self?.counter += 1
            let retryingDelay = self?.retryingDelay ?? Constants.defaultRetryingDelay
            DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + retryingDelay) {
                self?.load(request: request, completion: completion)
            }
        }
    }
}
