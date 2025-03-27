//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI
import OSLog
import TipKit


let logger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.abdulsamedarslan.ExpenseTracker",
                       category: "App")

@main
struct ExpenseTrackerApp: App {
    @AppStorage("selectedTheme")
    private var selectedTheme: Appearance = .system

    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
                .preferredColorScheme(selectedTheme.colorScheme)

        }
    }

    init() {
           do {
               // Configure and load all tips in the app.
               try Tips.resetDatastore()
               try Tips.configure()
           }
           catch {
               print("Error initializing tips: \(error)")
           }
       }

}

