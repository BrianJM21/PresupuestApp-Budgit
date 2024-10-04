//
//  ContentView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 07/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedView = 0
    @State private var isConfirmationDialogPresented: Bool = false
    @State private var isAddAccountViewPresented: Bool = false
    @State private var isAddBudgetViewPresented: Bool = false
    @State private var isAddTransactionViewPresented: Bool = false
    
    var body: some View {
        
        Picker("Views", selection: $selectedView) {
            Text("Accounts").tag(0)
            Text("Budgets").tag(1)
        }
        .pickerStyle(.segmented)
        .padding()
        .overlay(alignment: .center) {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
                Button("", systemImage: "plus.circle.fill") {
                    isConfirmationDialogPresented = true
                }
                .font(.system(size: 50))
                .confirmationDialog("What do you want to add?", isPresented: $isConfirmationDialogPresented) {
                    Button("Transaction") {
                        isAddTransactionViewPresented = true
                    }
                    Button("Account") {
                        isAddAccountViewPresented = true
                    }
                    Button("Budget") {
                        isAddBudgetViewPresented = true
                    }
                }
                .sheet(isPresented: $isAddTransactionViewPresented) {
                    AddTransactionView(isViewPresented: $isAddTransactionViewPresented)
                }
                .sheet(isPresented: $isAddAccountViewPresented) {
                    AddAccountView(isViewPresented: $isAddAccountViewPresented)
                }
                .sheet(isPresented: $isAddBudgetViewPresented) {
                    AddBudgetView(isViewPresented: $isAddBudgetViewPresented)
                }
            }
        }
        
        if selectedView == 0 {
            AccountView()
        } else {
            BudgetView()
        }
    }
    
}

#Preview {
    ContentView()
}
