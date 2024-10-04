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
    @State private var days: String = ""
    @State private var months: String = ""
    @State private var years: String = ""
    @Binding var isViewPresented: Bool
    @State private var isInvalidBalance: Bool = false
    @State private var isInvalidPeriodicity: Bool = false
    @State private var isInvalidField: Bool = false
    
    var body: some View {
        NavigationStack {
            Text("Add Budget")
                .font(.system(size: 20, weight: .bold))
            Form {
                LabeledContent("Name:") {
                    TextField("Enter budget name", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Balance:") {
                    TextField("Enter total budget balance", text: $balance)
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
                    Text("Custom").tag(Budget.Periodicity.custom(.init(days: 0, months: 0, years: 0)))
                }
                if periodicity == .custom(.init()) {
                    LabeledContent("Days:") {
                        TextField("Enter days periodicity", text: $days)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    LabeledContent("Months:") {
                        TextField("Enter months periodicity", text: $months)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    LabeledContent("Years:") {
                        TextField("Enter years periodicity", text: $years)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
                Button("Add budget") {
                    if name.isEmpty {
                        isInvalidField = true
                        return
                    }
                    if let balance = Double(balance), balance > 0, let currentBalance = Double(currentBalance) {
                        let newBudget = Budget(name: name, budget: balance, balance: currentBalance, periodicity: periodicity)
                        
                        if periodicity == .custom(.init()) {
                            var daysInt: Int = 0
                            var monthsInt: Int = 0
                            var yearsInt: Int = 0
                            
                            if !days.isEmpty {
                                if let days = Int(days), days > 0 {
                                    daysInt = days
                                } else {
                                    isInvalidPeriodicity = true
                                }
                            }
                            if !months.isEmpty {
                                if let months = Int(months), months > 0 {
                                    monthsInt = months
                                } else {
                                    isInvalidPeriodicity = true
                                }
                            }
                            if !years.isEmpty {
                                if let years = Int(years), years > 0 {
                                    yearsInt = years
                                } else {
                                    isInvalidPeriodicity = true
                                }
                            }
                            
                            newBudget.periodicity = .custom(.init(days: daysInt, months: monthsInt, years: yearsInt))
                            swiftDataContext.insert(newBudget)
                            isViewPresented = false
                        } else {
                            swiftDataContext.insert(newBudget)
                            isViewPresented = false
                        }
                    } else {
                        isInvalidBalance = true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .alert("Invalid account balance", isPresented: $isInvalidBalance) {
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
    AddBudgetView(isViewPresented: .constant(true))
}
