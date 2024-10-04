//
//  AddBudgetView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddBudgetView: View {
    
    @State private var name: String = ""
    @State private var balance: String = ""
    @State private var currentBalance: String = ""
    @State private var periodicity: Budget.Periodicity = .never
    @State private var days: String = ""
    @State private var months: String = ""
    @State private var years: String = ""
    @Binding var isViewPresented: Bool
    
    var body: some View {
        Form {
            LabeledContent("Name:") {
                TextField("Enter budget name", text: $name)
            }
            LabeledContent("Balance:") {
                TextField("Enter total budget balance", text: $balance)
            }
            LabeledContent("Current Balance:") {
                TextField("Enter current budget balance", text: $currentBalance)
            }
            Picker("Periodicity", selection: $periodicity) {
                Text("Never").tag(Budget.Periodicity.never)
                Text("Daily").tag(Budget.Periodicity.daily)
                Text("Weekly").tag(Budget.Periodicity.weekly)
                Text("Monthly").tag(Budget.Periodicity.monthly)
                Text("Yearly").tag(Budget.Periodicity.yearly)
                Text("Custom").tag(Budget.Periodicity.custom(.init(days: 0, months: 0, years: 0)))
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
                isViewPresented = false
            }
        }
    }
}

#Preview {
    AddBudgetView(isViewPresented: .constant(true))
}
