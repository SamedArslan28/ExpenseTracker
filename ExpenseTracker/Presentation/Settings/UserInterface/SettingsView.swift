//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @AppStorage("selectedTheme") private var selectedTheme: Appearance = .system
    @AppStorage("budget") private var budget: Double = 500.0
    @State private var showCurrencyPicker: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showFileExporter: Bool = false
    private let exportToCSVTip = DemoTip()

    var body: some View {
        Form {
            PreferencesSection(
                selectedCurrency: $selectedCurrency,
                showCurrencyPicker: $showCurrencyPicker,
                selectedTheme: $selectedTheme
            )
            BudgetSection(
                budget: $budget
            )
            DataManagementSection(
                showFileExporter: $showFileExporter,
                showDeleteAlert: $showDeleteAlert,
                exportToCSVTip: exportToCSVTip
            )
        }
        .navigationTitle("Settings")
        .fileExporter(
            isPresented: $showFileExporter,
            document: CSVDocument(
                transactions: SwiftDataService.shared.fetchExpenses()
            ),
            contentType: .commaSeparatedText,
            defaultFilename: "ExpenseTracker_Data_Export_\(Date.now).csv"
        ) { result in
            switch result {
            case .success(let url):
                logger.info("Successfully saved CSV file to: \(url)")
            case .failure(let error):
                logger.error("Failed to save CSV file: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
