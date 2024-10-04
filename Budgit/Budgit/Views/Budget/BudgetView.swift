//
//  BudgetView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI
import SwiftData

struct BudgetView: View {
    
    @Query(sort: \Budget.name) var budgets: [Budget]
    
    @State private var selectedBudget: Budget?
    @State private var isAddBudgetViewPresented: Bool = false
    
    var body: some View {
        
        if !budgets.isEmpty {
            Picker("Budgets", selection: $selectedBudget) {
                ForEach(budgets) { budget in
                    Text(budget.name).tag(budget as Budget?)
                }
            }
            .pickerStyle(.automatic)
            
            List {
                ForEach(selectedBudget?.transactions ?? [], id: \Transaction.timeStamp) { transaction in
                    VStack(alignment: .leading) {
                        Text(transaction.date.formatted())
                            .font(.system(size: 10))
                        LabeledContent(transaction.tile, value: transaction.amount, format: .currency(code: "MXN"))
                        Text(transaction.description ?? "")
                            .font(.system(size: 10))
                    }
                }
            }
        } else {
            ContentUnavailableView {
                Label("No budgets", systemImage: "chart.line.text.clipboard")
            } description: {
                Text("Start adding budgets to see them here.")
            } actions: {
                Button("Add budget") {
                    isAddBudgetViewPresented = true
                }
            }
            .sheet(isPresented: $isAddBudgetViewPresented) {
                AddBudgetView(isViewPresented: $isAddBudgetViewPresented)
            }

        }
    }
}

#Preview {
    BudgetView()
}
