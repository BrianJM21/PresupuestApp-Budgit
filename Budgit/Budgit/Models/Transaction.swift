//
//  Transaction.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 01/10/24.
//

import Foundation

struct Transaction: Codable {
    var timeStamp: Date = Date()
    var tile: String
    var description: String?
    var amount: Double
    var type: TransactionType
    
    enum TransactionType: String, Codable {
        case income = "income"
        case expense = "expense"
        case transfer = "transfer"
    }
}