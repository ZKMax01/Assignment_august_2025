//
//  VersionComparationTests.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import Testing
@testable import O2_Assignment

@Suite("VersionComparation")
struct VersionComparationTests {
    @Test func greaterThan() {
        let comparator = DefaultVersionComparator()
        #expect(comparator.isGreater("6.24", than: "6.1"))
        #expect(comparator.isGreater("6.1.1", than: "6.1"))
        #expect(!comparator.isGreater("6.1", than: "6.1"))
        #expect(!comparator.isGreater("6.0.9", than: "6.1"))
    }
}
