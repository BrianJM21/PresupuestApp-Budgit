//
//  Transaction.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 01/10/24.
//

import Foundation

struct Transaction {
    var timeStamp: Date
    var tile: String
    var description: String?
    var amount: Double
    var isIncome: Bool?
    var isExpense: Bool?
    var isTransfer: Bool?
}
