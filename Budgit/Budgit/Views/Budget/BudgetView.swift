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
                VStack(spacing: 5) {
                    HStack {
                        Text("Budget: \(selectedBudget.budgetBalance.formatted(.currency(code: "MXN")))")
                        Spacer()
                        Text("Balance: \(selectedBudget.currentBalance.formatted(.currency(code: "MXN")))")
                            .foregroundStyle(selectedBudget.currentBalance >= 0 ? Color.primary : .red)
                    }
                    if let startDate = selectedBudget.startDate, let endDate = selectedBudget.endDate {
                        HStack {
                            if let finishDate = selectedBudget.finishDate, finishDate < .now {
                                Label("Finished", systemImage: "checkmark.circle.fill")
                            }
                            Spacer()
                            if selectedBudget.isCumulative {
                                Label("Is cumulative", systemImage: "arrow.trianglehead.counterclockwise")
                            }
                        }
                        if startDate == endDate {
                            Text("for: \(startDate.formatted(date: .abbreviated, time: .omitted))")
                        } else {
                            HStack {
                                Text("from: \(startDate.formatted(date: .abbreviated, time: .omitted))")
                                Spacer()
                                Text("to: \(endDate.formatted(date: .abbreviated, time: .omitted))")
                            }
                        }
                    }
                }
                .padding()
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
                                HStack {
                                    Text(transaction.date.formatted())
                                        .font(.system(size: 10))
                                    Spacer()
                                    Text(transaction.accountName)
                                        .font(.system(size: 10))
                                }
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
    
    private func updateDatesForSelectedBudget() {
        guard let startDate = selectedBudget?.startDate,
              let endDate = selectedBudget?.endDate,
              let isFinite = selectedBudget?.isFinite,
              let isCumulative = selectedBudget?.isCumulative,
              let budgetBalance = selectedBudget?.budgetBalance,
              let periodicity = selectedBudget?.periodicity
        else { return }
        var newStartDate = Calendar.current.startOfDay(for: startDate)
        var newEndDate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: endDate)!)
        let finishDate: Date? = {
            if isFinite {
                return selectedBudget?.finishDate
            } else {
                return nil
            }
        }()
        var dateIterations: Double = 0
        let customTimeDifference = Calendar.current.dateComponents([.day, .month, .year], from: newStartDate, to: newEndDate)
        var dateRange = newStartDate...newEndDate
        while(!dateRange.contains(Date.now)) {
            if let finishDate, dateRange.contains(finishDate) { break }
            newStartDate = newEndDate
            switch periodicity {
            case .daily:
                newEndDate = Calendar.current.date(byAdding: .day, value: 1, to: newStartDate)!
            case .weekly:
                newEndDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: newStartDate)!
            case .monthly:
                newEndDate = Calendar.current.date(byAdding: .month, value: 1, to: newStartDate)!
            case .yearly:
                newEndDate = Calendar.current.date(byAdding: .yearForWeekOfYear, value: 1, to: newStartDate)!
            case .custom:
                newEndDate = Calendar.current.date(byAdding: customTimeDifference, to: newStartDate)!
            default:
                break
            }
            dateRange = newStartDate...newEndDate
            dateIterations += 1
        }
        selectedBudget?.startDate = newStartDate
        selectedBudget?.endDate = Calendar.current.date(byAdding: .day, value: -1, to: newEndDate)
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
