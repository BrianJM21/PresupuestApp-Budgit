//
//  BudgitApp.swift
//  Budgit
//
//  Created by Brian Jiménez Moedano on 07/09/24.
//

import SwiftUI
import SwiftData

@main
struct BudgitApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Account.self, Budget.self])
    }
}
