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
    let semanal = {
        var s = Budget(name: "Gasto Semanal", budget: 800, balance: 2000, periodicity: .weekly)
        s.transactions = [Transaction(tile: "gasto A", amount: 100, date: .now, type: .expense), Transaction(tile: "gasto B", amount: 200, date: .now, type: .expense)]
        return s
    }()
    let mensual = {
        var s = Budget(name: "Gasto Mensual", budget: 1200, balance: 3000, periodicity: .monthly)
        s.transactions = [Transaction(tile: "gasto A", amount: 300, date: .now, type: .income), Transaction(tile: "gasto B", amount: 400, date: .now, type: .transfer)]
        return s
    }()
    BudgetView(budgets: [semanal, mensual])
}
