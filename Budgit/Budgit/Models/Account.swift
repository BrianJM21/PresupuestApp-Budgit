//
//  Account.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 01/10/24.
//

import Foundation
import SwiftData

@Model class Account: Identifiable {
    var timeStamp: Date
    var name: String
    var balance: Double
    var transactions: [Transaction]
    
    init(name: String, balance: Double) {
        timeStamp = Date()
        self.name = name
        self.balance = balance
        self.transactions = []
    }
}
