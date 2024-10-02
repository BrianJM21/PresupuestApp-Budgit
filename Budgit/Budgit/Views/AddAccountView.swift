//
//  AddAccountView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 02/10/24.
//

import SwiftUI

struct AddAccountView: View {
    
    @State private var accountName: String = ""
    @State private var accountBalance: String = ""
    @Binding var isAddAccountViewPresented: Bool
    
    var body: some View {
        Form {
            LabeledContent("Account name:") {
                TextField("Enter account name", text: $accountName)
            }
            LabeledContent("Account balance:") {
                TextField("Enter current account balance", text: $accountBalance)
            }
            Button("Add account") {
                isAddAccountViewPresented = false
            }
        }
    }
}

#Preview {
    AddAccountView(isAddAccountViewPresented: .constant(true))
}
