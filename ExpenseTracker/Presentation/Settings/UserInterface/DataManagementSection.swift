//
//  DataManagementSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI

struct DataManagementSection: View {
    @Binding var showFileExporter: Bool
    @Binding var showDeleteAlert: Bool
    let exportToCSVTip: DemoTip

    var body: some View {
        Section(header: Text("Data")) {
            Button("Export Data to CSV") {
                showFileExporter = true
                exportToCSVTip.invalidate(reason: .actionPerformed)
            }
            .foregroundColor(.blue)
            .popoverTip(exportToCSVTip, arrowEdge: .bottom)

            Button("Clear All Data") {
                showDeleteAlert = true
            }
            .foregroundColor(.red)
            .alert("Clear All Data", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    SwiftDataService.shared.deleteAllItems()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete all data? This action cannot be undone.")
            }
        }
    }
}
