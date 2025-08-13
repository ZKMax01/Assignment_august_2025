//
//  VersionComparator.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation

struct VersionComparator {
    /// Returns true if `lhs` (e.g. "6.24") is strictly greater than `rhs` (e.g. "6.1").
    static func isGreater(_ lhs: String, than rhs: String) -> Bool {
        let a = lhs.split(separator: ".").map { Int($0) ?? 0 }
        let b = rhs.split(separator: ".").map { Int($0) ?? 0 }
        let n = max(a.count, b.count)
        for i in 0..<n {
            let ai = i < a.count ? a[i] : 0
            let bi = i < b.count ? b[i] : 0
            if ai != bi { return ai > bi }
        }
        return false
    }
}
