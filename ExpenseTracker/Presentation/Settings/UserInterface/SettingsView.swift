//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Query(FixedTransaction.getAll) private var fixedTransactions: [FixedTransaction]
    @Query(DefaultTransaction.getAll) private var defaultTransactions: [DefaultTransaction]

    @State private var showFileExporterResult: Bool = false
    @State private var fileExportMessage: String = ""
    @State private var showFileExporter: Bool = false


    var body: some View {
        NavigationView {
            Form {
                PreferencesSection()
                BudgetSection()
                DataManagementSection(showFileExporter: $showFileExporter)
            }
            .navigationTitle("Settings")
            .fileExporter(
                isPresented: $showFileExporter,
                document: CSVDocument(
                    transactions: fixedTransactions + defaultTransactions
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
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
