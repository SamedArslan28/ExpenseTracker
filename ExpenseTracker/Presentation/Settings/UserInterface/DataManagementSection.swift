//
//  DataManagementSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftData
import SwiftUI

struct DataManagementSection: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showDeleteAlert: Bool = false
    @State private var showFeedbackAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    @Binding var showFileExporter: Bool

    // FIXME: - Fix this tips name
    private let exportToCSVTip = DemoTip()

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
                    do {
                        try modelContext.delete(model: DefaultTransaction.self)
                        try modelContext.delete(model: FixedTransaction.self)
                        alertTitle = "Success"
                        alertMessage = "All data has been deleted successfully."
                        showFeedbackAlert = true
                    } catch {
                        alertTitle = "Error"
                        alertMessage = "Failed to delete data. Please try again later."
                        showFeedbackAlert = true
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete all data? This action cannot be undone.")
            }

            .alert(alertTitle, isPresented: $showFeedbackAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
}
