//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: String = "System Default" // Default theme
    var body: some Scene {
        WindowGroup {
            CustomTabView()
                .environment(\.colorScheme, (resolvedColorScheme ?? .light)) // Apply the selected color scheme
        }
    }

    // Helper to resolve the color scheme based on the user's selection
    private var resolvedColorScheme: ColorScheme? {
        switch selectedTheme {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil
        }
    }
}
