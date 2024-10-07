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
    var historyStartDate: Date?
    var startDate: Date?
    var endDate: Date?
    var isFinite: Bool = false
    var finishDate: Date?
    var isFinished: Bool = false
    var isCumulative: Bool = false
    
    init(name: String, budget: Double, balance: Double, periodicity: Periodicity) {
        self.timeStamp = Date()
        self.name = name
        self.budgetBalance = budget
        self.currentBalance = balance
        self.transactions = []
        self.periodicity = periodicity
    }
    
    enum Periodicity: String, Codable, Hashable {
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        case yearly = "yearly"
        case custom = "custom"
        case never = "never"
    }
}
