//
//  Environment.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 11/10/24.
//

import Foundation

struct EnvironmentVariable {
    static var currencyCode = Locale.current.currency?.identifier ?? ""
}
