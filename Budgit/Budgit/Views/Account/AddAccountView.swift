//
//  AddAccountView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddAccountView: View {
    
    @Environment(\.modelContext) var swiftDataContext
    
    @State private var name: String = ""
    @State private var balance: String = ""
    @Binding var isViewPresented: Bool
    @State private var isInvalidBalance: Bool = false
    @State private var isInvalidField: Bool = false
    
    var body: some View {
        NavigationStack {
            Text("Add Account")
                .font(.system(size: 20, weight: .bold))
            Form {
                LabeledContent("Name:") {
                    TextField("Enter account name", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Balance:") {
                    TextField("Enter current account balance", text: $balance)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numbersAndPunctuation)
                }
                Button("Add account") {
                    if name.isEmpty {
                        isInvalidField = true
                        return
                    }
                    if let balance = Double(balance) {
                        let newAccount = Account(name: name, balance: balance)
                        swiftDataContext.insert(newAccount)
                        isViewPresented = false
                    } else {
                        isInvalidBalance = true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .alert("Invalid account balance", isPresented: $isInvalidBalance) {
                    Button("OK", role: .cancel) {
                        isInvalidBalance = false
                    }
                }
                .alert("Invalid name input", isPresented: $isInvalidField) {
                    Button("OK", role: .cancel) {
                        isInvalidField = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        isViewPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    AddAccountView(isViewPresented: .constant(true))
}
