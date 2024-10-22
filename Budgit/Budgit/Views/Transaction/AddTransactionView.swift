//
//  AddTransactionView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    
    @Environment(\.modelContext) var swiftDataContext
    @Query(sort: \Account.name) var accounts: [Account]
    @Query(sort: \Budget.name) var budgets: [Budget]
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var date: Date = .now
    @State private var type: Transaction.TransactionType = .expense
    @State private var selectedAccount: Account?
    @State private var accountTransferDestination: Account?
    @State private var selectedBudget: Budget?
    @Binding var isViewPresented: Bool
    @State private var isInvalidAmount: Bool = false
    @State private var isInvalidField: Bool = false
    @State private var isInvalidAccount: Bool = false
    
    var body: some View {
        Group {
            HStack {
                Spacer()
                    .frame(maxWidth: .infinity)
                Text("Add Transaction")
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Button("Cancel") {
                    isViewPresented = false
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            Form {
                LabeledContent("Title:") {
                    TextField("Enter transaction title", text: $title)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Description:") {
                    TextField("Enter transaction description", text: $description)
                        .multilineTextAlignment(.trailing)
                }
                Picker("Transaction Type", selection: $type) {
                    Text("Income").tag(Transaction.TransactionType.income)
                    Text("Expense").tag(Transaction.TransactionType.expense)
                    Text("Transfer").tag(Transaction.TransactionType.transfer)
                }
                .onChange(of: type) { _, _ in
                    if type == .transfer {
                        selectedBudget = nil
                    }
                }
                LabeledContent("Amount:") {
                    TextField("Enter transaction amount", text: $amount)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                Picker("Account", selection: $selectedAccount) {
                    if selectedAccount == nil {
                        Text("No accounts available").tag(nil as Account?)
                    }
                    ForEach(accounts) { account in
                        Text(account.name).tag(account)
                    }
                }
                .onChange(of: selectedAccount) { _, _ in
                    if type == .transfer {
                        if let selectedAccount, selectedAccount == accountTransferDestination {
                            for account in accounts {
                                if account != selectedAccount {
                                    accountTransferDestination = account
                                    break
                                }
                            }
                        }
                    }
                }
                if type == .transfer {
                    Picker("Destination Account", selection: $accountTransferDestination) {
                        if accountTransferDestination == nil {
                            Text("No accounts available").tag(nil as Account?)
                        }
                        ForEach(accounts) { account in
                            if account.name != selectedAccount?.name {
                                Text(account.name).tag(account)
                            }
                        }
                    }
                    
                } else {
                    Picker("Budget", selection: $selectedBudget) {
                        Text("Budgetless transaction").tag(nil as Budget?)
                        ForEach(budgets) { budget in
                            Text(budget.name).tag(budget)
                        }
                    }
                    .onChange(of: selectedBudget) { _, _ in
                        if let endDate = selectedBudget?.endDate, date > endDate {
                            date = endDate
                        } else if let historyStartDate = selectedBudget?.historyStartDate, date < historyStartDate {
                            date = historyStartDate
                        }
                    }
                }
                if let historyStartDate = selectedBudget?.historyStartDate, let endDate = selectedBudget?.endDate {
                    DatePicker("Date:", selection: $date, in: historyStartDate...endDate, displayedComponents: .date)
                } else {
                    DatePicker("Date:", selection: $date, displayedComponents: .date)
                }
                Button("Add Transaction") {
                    if type == .transfer, accountTransferDestination == nil {
                        isInvalidAccount = true
                        return
                    }
                    if selectedAccount == nil {
                        isInvalidAccount = true
                        return
                    }
                    if title.isEmpty {
                        isInvalidField = true
                        return
                    }
                    if let amount = Double(amount), amount > 0 {
                        var newTransaction = Transaction(tile: title, description: description, amount: amount, date: date, type: type, accountName: selectedAccount?.name ?? "NA", budgetName: selectedBudget?.name ?? "Budgetless")
                        switch type {
                        case .income:
                            selectedAccount?.balance += amount
                            selectedAccount?.transactions.append(newTransaction)
                            selectedBudget?.transactions.append(newTransaction)
                            if let startDate = selectedBudget?.startDate, let endDate = selectedBudget?.endDate, let isCumulative = selectedBudget?.isCumulative {
                                let absoluteStartDate = Calendar.current.startOfDay(for: startDate)
                                let absoluteEndDate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: endDate)!)
                                if isCumulative {
                                    selectedBudget?.currentBalance += amount
                                } else if (absoluteStartDate...absoluteEndDate).contains(date) {
                                    selectedBudget?.currentBalance += amount
                                }
                            } else {
                                selectedBudget?.currentBalance += amount
                            }
                        case .expense:
                            selectedAccount?.balance -= amount
                            if let startDate = selectedBudget?.startDate, let endDate = selectedBudget?.endDate, let isCumulative = selectedBudget?.isCumulative {
                                let absoluteStartDate = Calendar.current.startOfDay(for: startDate)
                                let absoluteEndDate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: endDate)!)
                                if isCumulative {
                                    selectedBudget?.currentBalance -= amount
                                } else if (absoluteStartDate...absoluteEndDate).contains(date) {
                                    selectedBudget?.currentBalance -= amount
                                }
                            } else {
                                selectedBudget?.currentBalance -= amount
                            }
                            newTransaction.amount = -amount
                            selectedAccount?.transactions.append(newTransaction)
                            selectedBudget?.transactions.append(newTransaction)
                        case .transfer:
                            accountTransferDestination?.balance += amount
                            newTransaction.budgetName = "from: \(selectedAccount?.name ?? "NA")"
                            accountTransferDestination?.transactions.append(newTransaction)
                            selectedAccount?.balance -= amount
                            newTransaction.budgetName = "to: \(accountTransferDestination?.name ?? "NA")"
                            newTransaction.amount = -amount
                            selectedAccount?.transactions.append(newTransaction)
                        }
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
                .alert("Invalid account", isPresented: $isInvalidAccount) {
                    Button("OK", role: .cancel) {
                        isInvalidAccount = false
                    }
                }
            }
        }
        .onAppear {
            if !accounts.isEmpty {
                selectedAccount = accounts.first!
            }
            if !budgets.isEmpty {
                selectedBudget = budgets.first!
            }
            if accounts.count > 1 {
                accountTransferDestination = accounts.last!
            }
        }
    }
    
}

#Preview {
    AddTransactionView(isViewPresented: .constant(true))
}
