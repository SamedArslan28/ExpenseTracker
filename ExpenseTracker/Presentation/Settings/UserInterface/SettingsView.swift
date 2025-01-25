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

    let availableCurrencies: [String] = ["USD", "EUR", "GBP", "TRY", "JPY", "INR"]


    var body: some View {
        NavigationView {
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
                                CurrencyPicker(selectedCurrency: $selectedCurrency, currencies: availableCurrencies)
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
                }

                Section(header: Text("Data")) {
                    Button("Export Data to CSV") {
                        // do impl
                    }
                    .foregroundColor(.blue)

                    Button("Clear All Data") {
                        // do impl
                    }
                    .foregroundColor(.red)
                }

                Section(header: Text("About")) {
                    Button("Help & Support") {
                        // add impl
                    }
                    Button("About App") {
                        // add impl
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct CurrencyPicker: View {
    @Binding var selectedCurrency: String
    @Environment(\.dismiss) private var dismiss: DismissAction

    let currencies: [String]

    var body: some View {
        NavigationView {
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
    SettingsView()
}
