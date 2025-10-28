//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI
import OSLog
import TipKit
import SwiftData

let logger = os.Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.abdulsamedarslan.ExpenseTracker",
    category: "App"
)

@main
struct ExpenseTrackerApp: App {
    @AppStorage("selectedTheme")
    private var selectedTheme: Appearance = .system
    
    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
                .preferredColorScheme(selectedTheme.colorScheme)
        }
        .modelContainer(for:
                            [
                                FixedTransaction.self,
                                DefaultTransaction.self
                            ]
        )
    }
    
    init() {
        do {
            try Tips.configure()
        }
        catch {
            logger.error("Error initializing tips: \(error)")
        }
    }
    
}

