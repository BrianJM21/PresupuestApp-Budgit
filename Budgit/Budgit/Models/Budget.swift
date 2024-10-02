//
//  Budget.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 01/10/24.
//

import Foundation
import SwiftData

@Model class Budget: Identifiable {
    var timeStamp: Date
    var name: String
    var budgetBalance: Double
    var currentBalance: Double
    var transactions: [Transaction]
    var periodicity: Periodicity
    
    init(name: String, budget: Double, periodicity: Periodicity) {
        self.timeStamp = Date()
        self.name = name
        self.budgetBalance = budget
        self.currentBalance = budget
        self.transactions = []
        self.periodicity = periodicity
    }
}
