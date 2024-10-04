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
                    .keyboardType(.decimalPad)
            }
            Button("Add account") {
                isViewPresented = false
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    AddAccountView(isViewPresented: .constant(true))
}
