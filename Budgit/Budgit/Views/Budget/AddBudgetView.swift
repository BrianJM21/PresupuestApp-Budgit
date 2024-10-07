//
//  AddBudgetView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddBudgetView: View {
    
    @Environment(\.modelContext) var swiftDataContext
    
    @State private var name: String = ""
    @State private var balance: String = ""
    @State private var currentBalance: String = ""
    @State private var periodicity: Budget.Periodicity = .never
    @State private var startDate: Date = .now
    @State private var endDate: Date = .now
    @State private var isFinite: Bool = false
    @State private var finishDate: Date = .now
    @State private var isCumulative: Bool = false
    @Binding var isViewPresented: Bool
    @State private var isInvalidBalance: Bool = false
    @State private var isInvalidPeriodicity: Bool = false
    @State private var isInvalidField: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
                .frame(maxWidth: .infinity)
            Text("Add Budget")
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
            LabeledContent("Name:") {
                TextField("Enter budget name", text: $name)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Amount:") {
                TextField("Enter total budget amount", text: $balance)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numbersAndPunctuation)
            }
            LabeledContent("Current Balance:") {
                TextField("Enter current budget balance", text: $currentBalance)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numbersAndPunctuation)
            }
            Picker("Periodicity", selection: $periodicity) {
                Text("Never").tag(Budget.Periodicity.never)
                Text("Daily").tag(Budget.Periodicity.daily)
                Text("Weekly").tag(Budget.Periodicity.weekly)
                Text("Monthly").tag(Budget.Periodicity.monthly)
                Text("Yearly").tag(Budget.Periodicity.yearly)
                Text("Custom").tag(Budget.Periodicity.custom)
            }
            if periodicity != .never {
                DatePicker("Start date:", selection: $startDate, displayedComponents: .date)
            }
            if periodicity == .custom {
                DatePicker("End date:", selection: $endDate, in: startDate..., displayedComponents: .date)
            }
            if periodicity != .never {
                Toggle("Will finish?", isOn: $isFinite)
                if isFinite {
                    DatePicker("Finish date:", selection: $finishDate, in: startDate..., displayedComponents: .date)
                }
                Toggle("Is cumulative?", isOn: $isCumulative)
            }
            Button("Add budget") {
                if name.isEmpty {
                    isInvalidField = true
                    return
                }
                if let balance = Double(balance), balance > 0, let currentBalance = Double(currentBalance) {
                    let newBudget = Budget(name: name, budget: balance, balance: currentBalance, periodicity: periodicity)
                    switch periodicity {
                    case .daily:
                        newBudget.startDate = startDate
                        newBudget.endDate = startDate
                    case .weekly:
                        newBudget.startDate = startDate
                        if let baseDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startDate) {
                            newBudget.endDate = Calendar.current.date(byAdding: .day, value: -1, to: baseDate)
                        }
                    case .monthly:
                        newBudget.startDate = startDate
                        if let baseDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) {
                            newBudget.endDate = Calendar.current.date(byAdding: .day, value: -1, to: baseDate)
                        }
                    case .yearly:
                        newBudget.startDate = startDate
                        if let baseDate = Calendar.current.date(byAdding: .yearForWeekOfYear, value: 1, to: startDate) {
                            newBudget.endDate = Calendar.current.date(byAdding: .day, value: -1, to: baseDate)
                        }
                    case .custom:
                        newBudget.startDate = startDate
                        newBudget.endDate = endDate
                    case .never:
                        break
                    }
                    if newBudget.periodicity != .never {
                        newBudget.historyStartDate = startDate
                        newBudget.isFinite = isFinite
                        if isFinite {
                            newBudget.finishDate = finishDate
                        }
                        newBudget.isCumulative = isCumulative
                    }
                    if currentBalance != balance {
                        var adjustment = Transaction(tile: "Initial adjustment", amount: 0, date: startDate, type: .expense, accountName: "", budgetName: name)
                        if currentBalance < 0 {
                            adjustment.amount = balance + abs(currentBalance)
                        } else if currentBalance > balance {
                            adjustment.amount = currentBalance - balance
                            adjustment.type = .income
                        } else {
                            adjustment.amount = balance - currentBalance
                        }
                        newBudget.transactions.append(adjustment)
                    }
                    swiftDataContext.insert(newBudget)
                    isViewPresented = false
                } else {
                    isInvalidBalance = true
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .alert("Invalid budget balance", isPresented: $isInvalidBalance) {
                Button("OK", role: .cancel) {
                    isInvalidBalance = false
                }
            }
            .alert("Invalid name input", isPresented: $isInvalidField) {
                Button("OK", role: .cancel) {
                    isInvalidField = false
                }
            }
            .alert("Invalid periodicity", isPresented: $isInvalidPeriodicity) {
                Button("OK", role: .cancel) {
                    isInvalidBalance = false
                }
            }
        }
    }
}

#Preview {
    AddBudgetView(isViewPresented: .constant(true))
}
