//
//  O2_AssignmentApp.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import SwiftUI

@main
struct O2_AssignmentApp: App {
    @StateObject private var viewModel: CardViewModel
    
    init() {
        let env = ProcessInfo.processInfo.environment
        if env["UI_TEST_MODE"] == "1" {
            // Config via environment to control behavior in UI tests
            let remoteIOS = env["UI_TEST_REMOTE_IOS"] ?? "6.24"   // "6.0" to force failure
            let scratchNs = UInt64(env["UI_TEST_SCRATCH_NS"] ?? "200000000") ?? 200_000_000
            let actDelayNs = UInt64(env["UI_TEST_ACT_DELAY_NS"] ?? "0") ?? 0
            
            struct UITestActivationService: ActivationAPI {
                let remoteIOS: String
                let delayNs: UInt64
                func activate(using code: String) async throws -> Bool {
                    if delayNs > 0 { try await Task.sleep(nanoseconds: delayNs) }
                    let comparator: VersionComparing = DefaultVersionComparator()
                    return comparator.isGreater(remoteIOS, than: "6.1")
                }
            }
            
            let svc = UITestActivationService(remoteIOS: remoteIOS, delayNs: actDelayNs)
            _viewModel = StateObject(wrappedValue: CardViewModel(service: svc, scratchDelayNs: scratchNs))
        } else {
            _viewModel = StateObject(wrappedValue: CardViewModel(service: ActivationService()))
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
