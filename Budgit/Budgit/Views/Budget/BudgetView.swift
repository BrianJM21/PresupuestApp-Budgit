//
//  BudgetView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI
import SwiftData

struct BudgetView: View {
    
    @Environment(\.modelContext) var swiftDataContext
    @Query(sort: \Budget.name) var budgets: [Budget]
    
    @State private var selectedBudget: Budget?
    @State private var isAddBudgetViewPresented: Bool = false
    
    var body: some View {
        
        if !budgets.isEmpty {
            Picker("Budgets", selection: $selectedBudget) {
                if selectedBudget == nil {
                    Text("No budgets available").tag(nil as Budget?)
                }
                ForEach(budgets) { budget in
                    Text(budget.name).tag(budget as Budget?)
                }
            }
            .pickerStyle(.automatic)
            .onAppear {
                if !budgets.isEmpty {
                    selectedBudget = budgets.first!
                }
            }
            
            if let selectedBudget, selectedBudget.transactions.isEmpty {
                ContentUnavailableView {
                    Label("No transactions", systemImage: "pencil.and.list.clipboard")
                } description: {
                    Text("There are no transactions for the selected budget.")
                }
            } else {
                List {
                    ForEach(selectedBudget?.transactions.sorted { $0.date > $1.date } ?? [], id: \Transaction.timeStamp) { transaction in
                        VStack(alignment: .leading) {
                            Text(transaction.date.formatted())
                                .font(.system(size: 10))
                            LabeledContent(transaction.tile, value: transaction.amount, format: .currency(code: "MXN"))
                                .foregroundStyle(transaction.type == .expense ? .red : transaction.type == .income ? .green : .black)
                            Text(transaction.description ?? "")
                                .font(.system(size: 10))
                        }
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
