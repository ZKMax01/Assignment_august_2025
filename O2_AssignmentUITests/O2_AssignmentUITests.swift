//
//  O2_AssignmentUITests.swift
//  O2_AssignmentUITests
//
//  Created by ZKMax01 on 13/08/2025.
//

import XCTest

final class O2_AssignmentUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    /// Helper to launch the app with deterministic behavior for UI tests.
    private func makeApp(remoteIOS: String = "6.24",
                         scratchNs: UInt64 = 120_000_000,
                         actDelayNs: UInt64 = 0) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["UI_TEST_MODE"] = "1"
        app.launchEnvironment["UI_TEST_REMOTE_IOS"] = remoteIOS
        app.launchEnvironment["UI_TEST_SCRATCH_NS"] = "\(scratchNs)"
        app.launchEnvironment["UI_TEST_ACT_DELAY_NS"] = "\(actDelayNs)"
        return app
    }
    
    // MARK: - Navigation helpers (robust to presence/absence of accessibility identifiers)
    
    private func goToScratch(app: XCUIApplication) {
        if app.buttons["nav-scratch"].exists { app.buttons["nav-scratch"].tap(); return }
        if app.buttons["Scratch"].exists { app.buttons["Scratch"].tap(); return }
        app.buttons.element(matching: .button, identifier: "Go to Scratch Screen").tap()
    }
    
    private func goToActivate(app: XCUIApplication) {
        if app.buttons["nav-activate"].exists { app.buttons["nav-activate"].tap(); return }
        if app.buttons["Activate"].exists { app.buttons["Activate"].tap(); return }
        app.buttons.element(matching: .button, identifier: "Go to Activation Screen").tap()
    }
    
    private func back(app: XCUIApplication) {
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.exists { backButton.tap() }
    }
    
    // MARK: - Assertions
    
    private func assertState(_ expected: String, app: XCUIApplication, timeout: TimeInterval = 3) {
        // Expect "Current state: \(expected)"
        let panel = app.otherElements["card-panel"]
        XCTAssertTrue(panel.waitForExistence(timeout: 2), "card-panel not found")
        let pred = NSPredicate(format: "label == %@", "Current state: \(expected)")
        expectation(for: pred, evaluatedWith: panel)
        waitForExpectations(timeout: timeout)
    }
    
    // MARK: - Tests
    
    func testScratchCancelsOnBack() {
        // Give ourselves plenty of time to catch the in-progress state.
        let app = makeApp(scratchNs: 2_000_000_000) // 2s
        app.launch()

        goToScratch(app: app)

        let scratch = app.buttons["scratch-button"]
        XCTAssertTrue(scratch.waitForExistence(timeout: 2))

        scratch.tap()

        // Wait until the operation actually started (button disabled).
        let disabledPredicate = NSPredicate(format: "isEnabled == false")
        expectation(for: disabledPredicate, evaluatedWith: scratch)
        waitForExpectations(timeout: 1.5)

        // Cancel by leaving the screen
        back(app: app)
        XCTAssertTrue(app.navigationBars["Scratch Card"].waitForExistence(timeout: 2))

        // Final state back on main
        assertState("Unscratched", app: app, timeout: 4)
    }
    
    func testScratchRevealsCode() {
        let app = makeApp(scratchNs: 120_000_000)
        app.launch()
        
        goToScratch(app: app)
        app.buttons["scratch-button"].tap()
        
        XCTAssertTrue(app.staticTexts["Code revealed"].waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
