//
//  CardViewModel.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation
import SwiftUI

@MainActor
final class CardViewModel: ObservableObject {
    @Published private(set) var state: CardState = .unscratched
    @Published var errorMessage: String? = nil

    private let service: ActivationAPI
    private let scratchDelayNs: UInt64

    init(service: ActivationAPI, scratchDelayNs: UInt64 = 2_000_000_000) {
        self.service = service
        self.scratchDelayNs = scratchDelayNs
    }

    func beginScratch() -> Task<Void, Never> {
        state = .scratching
        return Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: self?.scratchDelayNs ?? 2_000_000_000)
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
        Task.detached { [service] in
            do {
                let ok = try await service.activate(using: code)
                await MainActor.run {
                    if ok { self.state = .activated(code: code) }
                    else  { self.errorMessage = "Activation failed (iOS version <= 6.1)."
                            self.state = .scratched(code: code) }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Activation error: \(error.localizedDescription)"
                    self.state = .scratched(code: code)
                }
            }
        }
    }
}
