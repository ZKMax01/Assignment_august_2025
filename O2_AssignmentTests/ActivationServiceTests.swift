//
//  ActivationServiceTests.swift
//  O2_AssignmentTests
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation
import Testing
@testable import O2_Assignment

@Suite(.serialized)
struct ActivationServiceTests {

    @Test
    func success_whenRemoteVersionGreater() async throws {
        let session = URLSession.mock(json: #"{"ios":"6.24"}"#, status: 200)
        let service = ActivationService(session: session)
        let ok = try await service.activate(using: "CODE")
        #expect(ok)
    }

    @Test
    func failure_whenRemoteVersionNotGreater() async {
        let session = URLSession.mock(json: #"{"ios":"6.0"}"#, status: 200)
        let service = ActivationService(session: session)

        do {
            let ok = try await service.activate(using: "CODE")
            #expect(!ok) // should be false, not thrown
        } catch {
            Issue.record("Did not expect error here: \(error)")
        }
    }

    @Test
    func throws_onNon200() async {
        let session = URLSession.mock(json: #"{"ios":"6.24"}"#, status: 500)
        let service = ActivationService(session: session)

        do {
            _ = try await service.activate(using: "CODE")
            Issue.record("Expected error, but got success")
        } catch {
            #expect(error is URLError)
        }
    }
}
