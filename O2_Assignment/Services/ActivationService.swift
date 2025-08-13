//
//  ActivationService.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation
import OSLog

protocol ActivationAPI {
    /// Returns true if the remote "ios" version is greater than 6.1 for the given `code`.
    func activate(using code: String) async throws -> Bool
}

struct ActivationService: ActivationAPI {
    struct Response: Decodable { let ios: String }
    
    var execute: (URLRequest) async throws -> (Data, URLResponse)
    var isVersionGreater: (String, String) -> Bool
    
    init(
        session: URLSession = .shared,
        isVersionGreater: @escaping (String, String) -> Bool = { $0.compare($1, options: .numeric) == .orderedDescending }
    ) {
        self.execute = { try await session.data(for: $0) }
        self.isVersionGreater = isVersionGreater
    }
    
    func activate(using code: String) async throws -> Bool {
        var components = URLComponents(string: "https://api.o2.sk/version")!
        components.queryItems = [URLQueryItem(name: "code", value: code)]
        guard let url = components.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await execute(request)
        
        guard
            let http = response as? HTTPURLResponse,
            (200..<300).contains(http.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        return isVersionGreater(decoded.ios, "6.1")
    }
}
