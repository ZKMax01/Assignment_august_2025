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

    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private let activationLog = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "O2_Assignment",
        category: "Activation"
    )

    func activate(using code: String) async throws -> Bool {
        var components = URLComponents(string: "https://api.o2.sk/version")!
        components.queryItems = [URLQueryItem(name: "code", value: code)]
        guard let url = components.url else { throw URLError(.badURL) }

        #if DEBUG
        activationLog.debug("→ Activation request url=\(url, privacy: .public), code=\(code, privacy: .private(mask: .hash))")
        #endif

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await session.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                #if DEBUG
                activationLog.error("← Non-HTTP response")
                #endif
                throw URLError(.badServerResponse)
            }

            #if DEBUG
            activationLog.debug("← HTTP status=\(http.statusCode, privacy: .public)")
            activationLog.debug("← Headers=\(String(describing: http.allHeaderFields), privacy: .public)")
            if let body = String(data: data, encoding: .utf8) {
                activationLog.debug("← Body=\(body, privacy: .public)")
            } else {
                activationLog.debug("← Body=<non-utf8 \(data.count) bytes>")
            }
            #endif

            guard (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let decoded = try JSONDecoder().decode(Response.self, from: data)
            
            let comparator: VersionComparing = DefaultVersionComparator()
            let isOk = comparator.isGreater(decoded.ios, than: "6.1")

            #if DEBUG
            activationLog.debug("Decoded ios='\(decoded.ios, privacy: .public)' > 6.1 ? \(isOk, privacy: .public)")
            #endif

            return isOk
        } catch {
            #if DEBUG
            activationLog.error("Activation failed: \(String(describing: error), privacy: .public)")
            #endif
            throw error
        }
    }
}
