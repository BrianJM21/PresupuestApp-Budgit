//
//  Periodicity.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 01/10/24.
//

import Foundation

enum Periodicity: Codable, Hashable {
    
    case daily
    case weekly
    case monthly
    case yearly
    case custom(CustomPeriodicity)
    case never
    
    struct CustomPeriodicity: Codable, Hashable {
        var days: Int
        var months: Int
        var years: Int
    }
}
