//
//  CardViewModelTests.swift
//  O2_AssignmentTests
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation
import Testing
@testable import O2_Assignment

@Suite("CardViewModel")
struct CardViewModelTests {

    // A tiny always-OK service so we don't hit the network.
    struct AlwaysOKActivation: ActivationAPI {
        func activate(using code: String) async throws -> Bool { true }
    }

    @Test @MainActor
    func scratchCompletesAfter2s() async throws {
        let viewModel = CardViewModel(service: AlwaysOKActivation())
        let t = viewModel.beginScratch()
        try await Task.sleep(nanoseconds: 2_200_000_000) // a bit over 2s

        // Expect the state to be .scratched(_)
        #expect({
            if case .scratched = viewModel.state { return true }
            return false
        }())
        _ = t // keep the task alive
    }

    @Test @MainActor
    func scratchCancelsWhenTaskCancelled() async throws {
        let viewModel = CardViewModel(service: AlwaysOKActivation())
        let t = viewModel.beginScratch()
        t.cancel()

        // Give cancellation a moment to propagate to the main actor
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.state == CardState.unscratched)
    }

    @Test @MainActor
    func activationTransitionsToActivated() async throws {
        let viewModel = CardViewModel(service: AlwaysOKActivation())

        // First, scratch to produce a code.
        _ = viewModel.beginScratch()
        try await Task.sleep(nanoseconds: 2_200_000_000)
        #expect({
            if case .scratched = viewModel.state { return true }
            return false
        }())

        // Then activate; detached task updates state shortly after.
        viewModel.activate()
        try await Task.sleep(nanoseconds: 150_000_000)

        #expect({
            if case .activated = viewModel.state { return true }
            return false
        }())
    }
}
