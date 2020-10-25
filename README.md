# PGNetworking
PGNetworking is an iOS module used for networking. It is distributed as **private Cocoapod**. It provides common abstractions used for sending a request over the network.

## Components
#### HTTPRequest
`HTTPRequest` is a model that maps into the request that is going to be sent over the network. You can specify its `method`, `headers`, `body`, `authenticationMethod` and url components
#### HTTPResponse
`HTTPResponse` is model closely tied with `HTTPURLResponse`. It has a reference to the `HTTPRequest`, telling you which request produced this response
#### HTTPError
`HTTPError` is an error that specifies the request that produced this error and the response (whole, partial or none) we received during the transimission. `HTTPError.Code` is a high level classification of the errors that can be received.
#### HTTPResult
`HTTPResult` is syntactic sugar defined as `Result<HTTPResponse, HTTPError>`
#### HTTPLoader
`HTTPLoader` class is a base class for every "`Loader`". It defines loading functionality and can link to the next executing loader. `HTTPLoader` provides the base implementation for loading functionality where it is calling the loading function on the next in chain `Loader`.
```
open func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
    if let nextLoader = nextLoader {
        nextLoader.load(request: request, completion: completion)
    } else {
        let error = HTTPError(code: .cannotConnect, request: request)
        completion(.failure(error))
    }
}
```
## Concrete Loaders
#### URLSessionLoader
`URLSessionLoader` is loading data from the network using `URLSessionTask`
#### PrintLoader
`PrintLoader` can help with the debugging since it puts print statements with the result of the loading. It is supposed to be used in a chain like
`PrintLoader --> URLSessionLoader`
#### EnvironmentLoader
`EnvironmentLoader` is used to specify server environment for `HTTPRequests`
#### AuthenticationLoader
`AuthenticationLoader` adds authentication to the `HTTPHeaders`. The consumer needs to provide closure that will apply the authentication headers the way he intented. Usage example of the `AuthenticationLoader` can be seen in file `LoaderTests.swift`.
#### RetryingLoader
`RetryingLoader` adds retrying logic to the network request. Based on the provided `RetryingCondition`, this `Loader` decides whether the next loader in chain should execute or not

## Future Plans
- Way to cancel the sent url tasks 
- P2P Connectivity like Bluetooth, WebSockets...
- Request Debouncing
- Caching Loader
