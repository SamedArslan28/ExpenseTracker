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
    private var selectedTheme: String = "System Default"

    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
                .environment(\.colorScheme, (resolvedColorScheme ?? .light))
                .modelContainer(for: TransactionItem.self)
        }
    }

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
