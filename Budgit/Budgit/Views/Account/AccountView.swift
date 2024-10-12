//
//  AccountView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    
    @Environment(\.modelContext) var swiftDataContext
    @Query(sort: \Account.name) var accounts: [Account]
    
    @State private var isAddAccountViewPresented: Bool = false
    
    var body: some View {
        if !accounts.isEmpty {
            NavigationStack {
                List {
                    ForEach(accounts.sorted { $0.name < $1.name }) { account in
                        NavigationLink(value: account) {
                            LabeledContent(account.name, value: account.balance, format: .currency(code: EnvironmentVariable.currencyCode))
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            swiftDataContext.delete(accounts[index])
                        }
                    }
                }
                .navigationDestination(for: Account.self) { account in
                    if account.transactions.isEmpty {
                        ContentUnavailableView {
                            Label("No transactions", systemImage: "pencil.and.list.clipboard")
                        } description: {
                            Text("There are no transactions for the selected account.")
                        }
                    } else {
                        List {
                            Section {
                                ForEach(account.transactions.sorted { $0.date > $1.date }, id: \Transaction.timeStamp) { transaction in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.system(size: 10))
                                            Spacer()
                                            Text(transaction.budgetName)
                                                .font(.system(size: 10))
                                        }
                                        LabeledContent(transaction.tile, value: transaction.amount, format: .currency(code: EnvironmentVariable.currencyCode))
                                            .foregroundStyle(transaction.type == .expense ? .red : transaction.type == .income ? .green : .black)
                                        Text(transaction.description ?? "")
                                            .font(.system(size: 10))
                                    }
                                    
                                }
                            } header: {
                                Text(account.name)
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                    }
                }
            }
        } else {
            ContentUnavailableView {
                Label("No accounts", systemImage: "creditcard")
            } description: {
                Text("Start adding accounts to see them here.")
            } actions: {
                Button("Add account") {
                    isAddAccountViewPresented = true
                }
            }
            .sheet(isPresented: $isAddAccountViewPresented) {
                AddAccountView(isViewPresented: $isAddAccountViewPresented)
            }
        }
    }
    
}

#Preview {
    AccountView()
}
