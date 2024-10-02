//
//  BudgetView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct BudgetView: View {
    
    var budgets: [Budget] = []
    
    @State private var selectedBudget: Budget?
    
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
                        Text(transaction.timeStamp.formatted())
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
                    print("add budget action")
                }
            }

        }
    }
}

#Preview {
    let semanal = {
        var s = Budget(name: "Gasto Semanal", budget: 800, periodicity: .weekly)
        s.transactions = [Transaction(tile: "gasto A", amount: 100, type: .expense), Transaction(tile: "gasto B", amount: 200, type: .expense)]
        return s
    }()
    let mensual = {
        var s = Budget(name: "Gasto Mensual", budget: 1200, periodicity: .monthly)
        s.transactions = [Transaction(tile: "gasto A", amount: 300, type: .income), Transaction(tile: "gasto B", amount: 400, type: .transfer)]
        return s
    }()
    BudgetView(budgets: [semanal, mensual])
}
