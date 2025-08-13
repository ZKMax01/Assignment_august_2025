//
//  CardPanel.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

struct CardPanel: View {
    let state: CardState
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                StateBadge(state: state)
                Spacer()
            }
            
            switch state {
            case .unscratched:
                Text("Your scratch card is ready.")
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                    .transition(.opacity)
            case .scratching:
                Text("Scratching…")
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                    .transition(.opacity)
            case .scratched(let code):
                VStack(alignment: .leading, spacing: 8) {
                    Text("Code revealed")
                        .font(Font.system(size: 18, weight: .semibold))
                    textCode(code: code)
                }
                .transition(.opacity)
            case .activating(let code):
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activating with code…")
                        .font(Font.system(size: 18, weight: .semibold))
                    textCode(code: code)
                }
                .transition(.opacity)
            case .activated(let code):
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activated")
                        .font(Font.system(size: 18, weight: .semibold))
                    textCode(code: code)
                }
                .transition(.opacity)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .accessibilityElement()
        .accessibilityIdentifier("card-panel")
        .accessibilityLabel(Text(state.displayText))
        .background(
            LinearGradient(stops: [
                .init(color: state.tint.opacity(0.18), location: 0),
                .init(color: .clear, location: 1)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(state.tint.opacity(0.3))
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private func textCode(code: String) -> some View {
        Text(code)
            .font(Font.system(size: 14, design: .monospaced))
            .lineLimit(1)
    }
}

#Preview {
    CardPanel(state: .activated(code: UUID().uuidString))
}
