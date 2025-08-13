//
//  CardState.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

enum CardState: Equatable {
    case unscratched
    case scratching
    case scratched(code: String)
    case activating(code: String)
    case activated(code: String)
}

extension CardState {
    var displayText: String {
        switch self {
        case .unscratched: return "Unscratched"
        case .scratching: return "Scratching…"
        case .scratched: return "Scratched"
        case .activating: return "Activating…"
        case .activated: return "Activated"
        }
    }
    
    var iconName: String {
        switch self {
        case .unscratched: return "rectangle.dashed"
        case .scratching: return "wand.and.stars"
        case .scratched: return "qrcode"
        case .activating: return "bolt.fill"
        case .activated: return "checkmark.seal.fill"
        }
    }
    
    var tint: Color {
        switch self {
        case .unscratched: return .gray
        case .scratching: return .orange
        case .scratched: return .blue
        case .activating: return .purple
        case .activated: return .green
        }
    }
}
