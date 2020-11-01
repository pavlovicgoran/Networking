//
//  URLSessionLoader.swift
//  Networking
//
//  Created by Goran Pavlovic on 23/10/2020.
//

import Foundation

public class URLSessionLoader: HTTPLoader {
    private let session: URLSession
    private let networkReachability: NetworkReachability
    
    public init(
        session: URLSession = URLSession.shared,
        networkReachability: NetworkReachability = NetworkManager.shared
    ) {
        self.session = session
        self.networkReachability = networkReachability
    }
    
    #warning("Figure out a way to support canceling tasks")
    public override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        // Try to construct the url
        guard let url = request.url else {
            let error = HTTPError(
                code: .couldntBuildUrl,
                request: request
            )
            completion(.failure(error))
            return
        }
        
        guard networkReachability.isNetConnected else {
            let error = HTTPError(
                code: .cannotConnect,
                request: request
            )
            completion(.failure(error))
            return
        }
        
        // construct url request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        // copy over custom headers
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        
        
        if request.body.isEmpty == false {
            // copy over any additional data
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(header, forHTTPHeaderField: value)
            }
            
            // try serializing body data
            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
                let httpError = HTTPError(
                    code: .invalidBodySerialization,
                    request: request
                )
                completion(.failure(httpError))
                return
            }
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            // parse response into the HTTPResult
            let result = HTTPResult(request: request, responseData: data, response: response, error: error)
            completion(result)
        }
        
        dataTask.resume()
    }
}

extension HTTPResult {
    init(request: HTTPRequest, responseData: Data?, response: URLResponse?, error: Error?) {
        var httpResponse: HTTPResponse?
        if let r = response as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, response: r, body: responseData ?? Data())
        }

        if let e = error as? URLError {
            #warning("Parse all HTTP Codes")
            let code: HTTPError.Code
            switch e.code {
                case .badURL: code = .invalidRequest
                case .unsupportedURL: code = .unknown
                case .cannotFindHost: code = .unknown
                default: code = .unknown
            }
            self = .failure(HTTPError(code: code, request: request, response: httpResponse, underlyingError: e))

        } else if let someError = error {
            // an error, but not a URL error
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: someError))

        } else if let response = httpResponse {
            // not an error, and an HTTPURLResponse
            
            // Codes like 500, 400, 404 are all resulting in the success
            // This is left so the consumer can implement the custom specific logic
            // when receive this code and the response
            self = .success(response)

        } else {
            // not an error, but also not an HTTPURLResponse
            self = .failure(HTTPError(code: .invalidResponse, request: request, underlyingError: error))
        }
    }
}
