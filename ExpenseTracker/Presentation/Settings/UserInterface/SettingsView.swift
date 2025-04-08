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
    @State private var showFileExporterResult: Bool = false
    @State private var showCurrencyPicker: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showFileExporter: Bool = false
    @State private var fileExportMessage: String = "" 
    private let exportToCSVTip = DemoTip()

    var body: some View {
        Form {
            PreferencesSection(
                selectedCurrency: $selectedCurrency,
                showCurrencyPicker: $showCurrencyPicker,
                selectedTheme: $selectedTheme
            )
            BudgetSection()
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
            defaultFilename: "ExpenseTracker_Data_Export_\(Date.now.formatted(date: .long, time: .omitted)).csv"
        ) { result in
            switch result {
            case .success(let url):
                fileExportMessage = "CSV successfully saved to:\n\(url.lastPathComponent)"
                showFileExporterResult = true
                logger.info("Successfully saved CSV file to: \(url)")
            case .failure(let error):
                fileExportMessage = "Failed to save CSV:\n\(error.localizedDescription)"
                showFileExporterResult = true
                logger.error("Failed to save CSV file: \(error)")
            }
        }
        .alert("Export Result", isPresented: $showFileExporterResult) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(fileExportMessage)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
