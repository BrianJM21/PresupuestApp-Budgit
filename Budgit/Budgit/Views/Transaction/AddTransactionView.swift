//
//  AddTransactionView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.modelContext) var swiftDataContext
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var date: Date = .now
    @State private var type: Transaction.TransactionType = .expense
    @Binding var isViewPresented: Bool
    @State private var isInvalidAmount: Bool = false
    @State private var isInvalidField: Bool = false
    
    var body: some View {
        NavigationStack {
            Text("Add Transaction")
                .font(.system(size: 20, weight: .bold))
            Form {
                LabeledContent("Title:") {
                    TextField("Enter transaction title", text: $title)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Description:") {
                    TextField("Enter transaction description", text: $description)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Amount:") {
                    TextField("Enter transaction amount", text: $amount)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
                DatePicker("Fecha:", selection: $date)
                Picker("Transaction Type", selection: $type) {
                    Text("Income").tag(Transaction.TransactionType.income)
                    Text("Expense").tag(Transaction.TransactionType.expense)
                    Text("Transfer").tag(Transaction.TransactionType.transfer)
                }
                Button("Add Transaction") {
                    if title.isEmpty {
                        isInvalidField = true
                        return
                    }
                    if let amount = Double(amount), amount > 0 {
                        let newTransaction = Transaction(tile: title, description: description, amount: amount, date: date, type: type)
                        
                        isViewPresented = false
                    } else {
                        isInvalidAmount = true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .alert("Invalid transaction amount", isPresented: $isInvalidAmount) {
                    Button("OK", role: .cancel) {
                        isInvalidAmount = false
                    }
                }
                .alert("Invalid title input", isPresented: $isInvalidField) {
                    Button("OK", role: .cancel) {
                        isInvalidField = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        isViewPresented = false
                    }
                }
            }
        }
    }
    
}

#Preview {
    AddTransactionView(isViewPresented: .constant(true))
}
