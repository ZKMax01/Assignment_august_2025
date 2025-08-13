//
//  CardStore.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation
import SwiftUI

@MainActor
final class CardStore: ObservableObject {
    @Published private(set) var state: ScratchCardState = .unscratched
    @Published var errorMessage: String? = nil

    private let service: ActivationServicing

    init(service: ActivationServicing = ActivationService()) {
        self.service = service
    }

    // Returns a Task representing the scratch operation (caller may cancel).
    func beginScratch() -> Task<Void, Never> {
        state = .scratching
        return Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                try Task.checkCancellation()
                let code = UUID().uuidString
                await MainActor.run { self?.state = .scratched(code: code) }
            } catch is CancellationError {
                await MainActor.run { self?.state = .unscratched }
            } catch {
                await MainActor.run {
                    self?.errorMessage = "Scratch failed: \(error.localizedDescription)"
                    self?.state = .unscratched
                }
            }
        }
    }

    func activate() {
        guard case let .scratched(code) = state else { return }
        state = .activating(code: code)

        // Use a detached task so leaving the screen doesn't cancel the work.
        Task.detached { [service] in
            do {
                let ok = try await service.activate(using: code)
                await MainActor.run {
                    if ok {
                        self.state = .activated(code: code)
                    } else {
                        self.errorMessage = "Activation failed (iOS version <= 6.1)."
                        self.state = .scratched(code: code) // remain scratched
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Activation error: \(error.localizedDescription)"
                    self.state = .scratched(code: code) // remain scratched
                }
            }
        }
    }
}
