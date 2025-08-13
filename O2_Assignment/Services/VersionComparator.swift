//
//  VersionComparator.swift
//  O2_Assignment
//
//  Created by ZKMax01 on 13/08/2025.
//

import Foundation

protocol VersionComparing {
    func isGreater(_ lhs: String, than rhs: String) -> Bool
}

struct DefaultVersionComparator: VersionComparing {
    func isGreater(_ lhs: String, than rhs: String) -> Bool {
        lhs > rhs
    }
}
