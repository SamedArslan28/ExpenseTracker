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

    let availableCurrencies: [String] = ["USD", "EUR", "GBP", "TRY", "JPY", "INR"]
    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                HStack {
                    Text("Currency")
                    Spacer()
                    Text(selectedCurrency)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showCurrencyPicker = true
                        }
                        .sheet(isPresented: $showCurrencyPicker) {
                            CurrencyPicker(selectedCurrency: $selectedCurrency,
                                           currencies: availableCurrencies)
                        }
                }
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(Appearance.allCases) { appearance in
                        Text(appearance.rawValue.capitalized)
                            .tag(appearance)
                    }
                }
            }

            Section(header: Text("Budget")) {
                VStack(alignment: .leading) {
                    Text("Set Monthly Budget: $\(Int(budget))")
                    Slider(value: $budget, in: 100...5_000, step: 50)
                }
                NavigationLink("Add Fixed Income", destination: FixedIncomeView())
            }

            Section(header: Text("Data")) {
                Button("Export Data to CSV") {
                    saveCSVFile(transactions: SwiftDataService.shared.fetchExpenses())
                }
                .foregroundColor(.blue)

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
        .navigationTitle(Text("Settings"))
    }

    @discardableResult
    func saveCSVFile(transactions: [TransactionItem]) -> URL? {
        let csvString = TransactionItem.convertToCSV(transactions: transactions)

        let fileManager = FileManager.default
        do {
            let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = directory.appendingPathComponent("transactions.csv")

            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)

            print("CSV file saved at: \(fileURL)")
            return fileURL
        } catch {
            print("Error saving CSV file: \(error)")
            return nil
        }
    }
}

struct CurrencyPicker: View {
    @Binding var selectedCurrency: String
    @Environment(\.dismiss) private var dismiss: DismissAction

    let currencies: [String]

    var body: some View {
        NavigationStack {
            List(currencies, id: \.self) { currency in
                Button {
                    selectedCurrency = currency
                } label: {
                    HStack {
                        Text(currency)
                        if selectedCurrency == currency {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Currency")
            .onChange(of: selectedCurrency) { _, _ in
                dismiss()
            }
        }
    }
}
#Preview {
    NavigationStack {
        SettingsView()
    }
}
