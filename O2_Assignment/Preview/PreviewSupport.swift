//
//  PreviewSupport.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

#if DEBUG
import SwiftUI

struct PreviewActivationService: ActivationAPI {
    func activate(using code: String) async throws -> Bool { true }
}
#endif
