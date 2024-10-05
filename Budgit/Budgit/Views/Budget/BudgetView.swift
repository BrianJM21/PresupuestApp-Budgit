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
            .onChange(of: selectedBudget) {
                updateDatesForSelectedBudget()
            }
            
            if let selectedBudget {
                HStack {
                    Text("Budget: \(selectedBudget.budgetBalance.formatted(.currency(code: "MXN")))")
                    Spacer()
                    Text("Balance: \(selectedBudget.currentBalance.formatted(.currency(code: "MXN")))")
                        .foregroundStyle(selectedBudget.currentBalance >= 0 ? .black : .red)
                }
                .padding()
                if let startDate = selectedBudget.startDate, let endDate = selectedBudget.endDate {
                    if startDate == endDate {
                        Text("for: \(startDate.formatted(date: .abbreviated, time: .omitted))")
                    } else {
                        HStack {
                            Text("from: \(startDate.formatted(date: .abbreviated, time: .omitted))")
                            Spacer()
                            Text("to: \(endDate.formatted(date: .abbreviated, time: .omitted))")
                        }
                        .padding()
                    }
                }
                if selectedBudget.transactions.isEmpty {
                    ContentUnavailableView {
                        Label("No transactions", systemImage: "pencil.and.list.clipboard")
                    } description: {
                        Text("There are no transactions for the selected budget.")
                    }
                } else {
                    List {
                        ForEach(selectedBudget.transactions.sorted { $0.date > $1.date }, id: \Transaction.timeStamp) { transaction in
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
    
    func updateDatesForSelectedBudget() {
        guard let startDate = selectedBudget?.startDate,
              let endDate = selectedBudget?.endDate,
              !(startDate...endDate).contains(Date.now),
              let isFinite = selectedBudget?.isFinite,
              let isCumulative = selectedBudget?.isCumulative,
              let budgetBalance = selectedBudget?.budgetBalance
        else { return }
        var newStartDate = startDate
        var newEndDate = endDate
        let finishDate: Date? = {
            if isFinite {
                return selectedBudget?.finishDate
            } else {
                return nil
            }
        }()
        var dateIterations: Double = 1
        let timeDifference = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        var dateRange = startDate...endDate
        while(!dateRange.contains(Date.now)) {
            if let finishDate, dateRange.contains(finishDate) {
                break
            }
            newStartDate = Calendar.current.date(byAdding: .day, value: 1, to: newEndDate)!
            newEndDate = Calendar.current.date(byAdding: timeDifference, to: newStartDate)!
            dateRange = newStartDate...newEndDate
            dateIterations += 1
        }
        selectedBudget?.startDate = newStartDate
        selectedBudget?.endDate = newEndDate
        if isCumulative {
            selectedBudget?.currentBalance += budgetBalance * dateIterations
        } else {
            selectedBudget?.currentBalance = budgetBalance
        }
    }
    
}

#Preview {
    BudgetView()
}
