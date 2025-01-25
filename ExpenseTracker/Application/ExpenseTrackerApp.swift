//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData
import SwiftUI

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
}
