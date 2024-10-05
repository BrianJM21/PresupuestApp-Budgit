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
    var startDate: Date?
    var endDate: Date?
    var isFinite: Bool = false
    var finishDate: Date?
    var isCumulative: Bool = false
    
    init(name: String, budget: Double, balance: Double, periodicity: Periodicity) {
        self.timeStamp = Date()
        self.name = name
        self.budgetBalance = budget
        self.currentBalance = balance
        self.transactions = []
        self.periodicity = periodicity
    }
    
    enum Periodicity: Codable, Hashable {
        case daily
        case weekly
        case monthly
        case yearly
        case custom
        case never
    }
}
