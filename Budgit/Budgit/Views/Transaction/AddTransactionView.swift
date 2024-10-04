//
//  AddTransactionView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddTransactionView: View {
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var type: Transaction.TransactionType = .expense
    @Binding var isViewPresented: Bool
    
    var body: some View {
        Form {
            LabeledContent("Title:") {
                TextField("Enter transaction title", text: $title)
            }
            LabeledContent("Description:") {
                TextField("Enter transaction description", text: $description)
            }
            LabeledContent("Amount:") {
                TextField("Enter transaction amount", text: $amount)
            }
            Picker("Transaction Type", selection: $type) {
                Text("Income").tag(Transaction.TransactionType.income)
                Text("Expense").tag(Transaction.TransactionType.expense)
                Text("Transfer").tag(Transaction.TransactionType.transfer)
            }
            Button("Add Transaction") {
                isViewPresented = false
            }
        }
        .navigationBarTitle("Add Transaction")
    }
    
}

#Preview {
    AddTransactionView(isViewPresented: .constant(true))
}
