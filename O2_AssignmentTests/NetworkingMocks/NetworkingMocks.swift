//
//  NetworkingMocks.swift
//  O2_AssignmentTests
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var statusCode: Int = 200
    static var responseHeaders: [String: String] = ["Content-Type": "application/json"]
    static var responseBody: Data = Data()

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let http = HTTPURLResponse(
            url: request.url!,
            statusCode: Self.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: Self.responseHeaders
        )!
        client?.urlProtocol(self, didReceive: http, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.responseBody)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension URLSession {
    /// Build a session that returns the given JSON and status.
    static func mock(json: String, status: Int = 200, headers: [String: String] = ["Content-Type": "application/json"]) -> URLSession {
        let cfg = URLSessionConfiguration.ephemeral
        cfg.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.statusCode = status
        MockURLProtocol.responseHeaders = headers
        MockURLProtocol.responseBody = Data(json.utf8)
        return URLSession(configuration: cfg)
    }
}
