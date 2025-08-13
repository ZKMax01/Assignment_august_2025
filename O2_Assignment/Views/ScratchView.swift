//
//  ScratchView.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

struct ScratchView: View {
    @EnvironmentObject var viewModel: CardViewModel
    @State private var scratchTask: Task<Void, Never>? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                CardPanel(state: viewModel.state)

                Button(action: startScratch) {
                    Label(isScratching ? "Scratching…" : "Scratch (2s)", systemImage: "wand.and.stars")
                        .font(Font.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isScratching)
                .accessibilityIdentifier("scratch-button")

                Text("Leaving this screen cancels scratching.")
                    .font(Font.system(size: 13))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Scratch")
            .navigationBarTitleDisplayMode(.inline)

            if isScratching {
                LoadingOverlay(title: "Scratching…")
            }
        }
        .onDisappear { scratchTask?.cancel() }
    }

    private var isScratching: Bool {
        if case .scratching = viewModel.state { return true }
        return false
    }

    private func startScratch() {
        scratchTask?.cancel()
        scratchTask = viewModel.beginScratch()
    }
}
