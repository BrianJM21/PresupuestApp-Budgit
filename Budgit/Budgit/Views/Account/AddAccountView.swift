//
//  AddAccountView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddAccountView: View {
    
    @State private var name: String = ""
    @State private var balance: String = ""
    @Binding var isViewPresented: Bool
    @State private var isInvalidBalance: Bool = false
    
    var body: some View {
        HStack {
            Text("Add Account")
                .font(.system(size: 20, weight: .bold))
            Button("Cancel") {
                isViewPresented = false
            }
        }
        .padding()
        
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
                if let balance = Double(balance) {
                    let newAccount = Account(name: name, balance: balance)
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
        }
    }
}

#Preview {
    AddAccountView(isViewPresented: .constant(true))
}
