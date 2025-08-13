//
//  StateBadge.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

struct StateBadge: View {
    let state: CardState
    var body: some View {
        Label(state.displayText, systemImage: state.iconName)
            .font(Font.system(size: 14, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(state.tint.opacity(0.12))
            .foregroundStyle(state.tint)
            .clipShape(Capsule())
            .accessibilityLabel(state.displayText)
            .accessibilityIdentifier("state-text")
    }
}

#Preview {
    StateBadge(state: .scratching)
}
