//
//  LoadingOverlay.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

struct LoadingOverlay: View {
    let title: String
    var body: some View {
        ZStack {
            Color.black.opacity(0.15).ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                Text(title)
                    .font(Font.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .transition(.opacity)
    }
}

#Preview {
    LoadingOverlay(title: "Loading...")
}
