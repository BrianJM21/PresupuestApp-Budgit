//
//  AccountView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AccountView: View {
    
    var accounts: [Account] = []
    
    var body: some View {
        
        if !accounts.isEmpty {
            List {
                ForEach(accounts) { account in
                    LabeledContent(account.name, value: account.balance, format: .currency(code: "MXN"))
                }
            }
            
            Button("", systemImage: "plus.circle.fill") {
                print("Add action")
            }
            .font(.system(size: 50))
        } else {
            ContentUnavailableView {
                Label("No accounts", systemImage: "creditcard")
            } description: {
                Text("Start adding accounts to see them here.")
            } actions: {
                Button("Add account") {
                    print("add account action")
                }
            }

        }
    }
    
}

#Preview {
    AccountView(accounts: [Account(name: "Efectivo", balance: 200)])
}
