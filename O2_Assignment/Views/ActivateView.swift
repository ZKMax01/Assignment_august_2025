//
//  ActivateView.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

struct ActivateView: View {
    @EnvironmentObject var viewModel: CardViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                CardPanel(state: viewModel.state)

                Button(action: { viewModel.activate() }) {
                    Label(canActivate ? "Activate" : labelForState, systemImage: iconForState)
                        .font(Font.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canActivate)
                .accessibilityIdentifier("activate-button")

                Text("Activation continues if you leave this screen.")
                    .font(Font.system(size: 13))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Activate")
            .navigationBarTitleDisplayMode(.inline)

            if isActivating {
                LoadingOverlay(title: "Activating…")
            }
        }
    }

    private var canActivate: Bool {
        if case .scratched = viewModel.state { return true }
        return false
    }

    private var isActivating: Bool {
        if case .activating = viewModel.state { return true }
        return false
    }

    private var labelForState: String {
        switch viewModel.state {
        case .unscratched: return "Scratch first"
        case .scratching: return "Scratching…"
        case .scratched: return "Activate"
        case .activating: return "Activating…"
        case .activated: return "Already activated"
        }
    }

    private var iconForState: String {
        switch viewModel.state {
        case .unscratched: return "questionmark"
        case .scratching: return "wand.and.stars"
        case .scratched: return "bolt.fill"
        case .activating: return "clock"
        case .activated: return "checkmark.seal.fill"
        }
    }
}
