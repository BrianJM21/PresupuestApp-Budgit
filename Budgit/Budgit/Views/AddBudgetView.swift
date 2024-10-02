//
//  AddBudgetView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddBudgetView: View {
    
    @State private var budgetName: String = ""
    @State private var budgetBalance: String = ""
    @State private var currentBudgetBalance: String = ""
    @State private var periodicity: Periodicity = .never
    @State private var days: String = ""
    @State private var months: String = ""
    @State private var years: String = ""
    @Binding var isAddBudgetViewPresented: Bool
    
    var body: some View {
        Form {
            LabeledContent("Budget name:") {
                TextField("Enter budget name", text: $budgetName)
            }
            LabeledContent("Budget balance:") {
                TextField("Enter budget balance", text: $budgetBalance)
            }
            LabeledContent("Current budget balance:") {
                TextField("Enter current budget balance", text: $currentBudgetBalance)
            }
            Picker("Periodicity", selection: $periodicity) {
                Text("Never").tag(Periodicity.never)
                Text("Daily").tag(Periodicity.daily)
                Text("Weekly").tag(Periodicity.weekly)
                Text("Monthly").tag(Periodicity.monthly)
                Text("Yearly").tag(Periodicity.yearly)
                Text("Custom").tag(Periodicity.custom(.init(days: 0, months: 0, years: 0)))
            }
            if periodicity == .custom(.init(days: 0, months: 0, years: 0)) {
                LabeledContent("Days:") {
                    TextField("Enter days periodicity", text: $days)
                }
                LabeledContent("Months:") {
                    TextField("Enter months periodicity", text: $months)
                }
                LabeledContent("Years:") {
                    TextField("Enter years periodicity", text: $years)
                }
            }
            Button("Add budget") {
                isAddBudgetViewPresented = false
            }
        }
    }
}

#Preview {
    AddBudgetView(isAddBudgetViewPresented: .constant(true))
}
