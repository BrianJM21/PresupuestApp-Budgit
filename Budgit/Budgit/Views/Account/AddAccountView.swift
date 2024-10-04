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
        Form {
            LabeledContent("Name:") {
                TextField("Enter account name", text: $name)
            }
            LabeledContent("Balance:") {
                TextField("Enter current account balance", text: $balance)
            }
            Button("Add account") {
                isViewPresented = false
            }
        }
    }
}

#Preview {
    AddAccountView(isViewPresented: .constant(true))
}
