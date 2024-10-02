//
//  ContentView.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 07/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedView = 0
    
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
                    print("add action button")
                }
                .font(.system(size: 50))
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
