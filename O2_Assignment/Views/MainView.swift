//
//  MainView.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: CardViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                CardPanel(state: viewModel.state)
                    .accessibilityLabel("Current state: \(viewModel.state.displayText)")
                    .animation(.smooth(duration: 0.25), value: viewModel.state)

                HStack(spacing: 14) {
                    NavigationLink {
                        ScratchView()
                    } label: {
                        Label("Scratch", systemImage: "wand.and.stars")
                            .font(Font.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("nav-scratch")

                    NavigationLink {
                        ActivateView()
                    } label: {
                        Label("Activate", systemImage: "bolt.fill")
                            .font(Font.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("nav-activate")
                }

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Scratch Card")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview("Main") {
    MainView()
        .environmentObject(CardViewModel(service: PreviewActivationService()))
}
