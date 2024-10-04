//
//  AccountView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    
    @Query(sort: \Account.name) var accounts: [Account]
    
    @State private var isAddAccountViewPresented: Bool = false
    
    var body: some View {
        if !accounts.isEmpty {
            List {
                ForEach(accounts) { account in
                    LabeledContent(account.name, value: account.balance, format: .currency(code: "MXN"))
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
