//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @AppStorage("selectedTheme") private var selectedTheme: String = "Dark"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("budget") private var budget: Double = 500.0

    @State private var showCurrencyPicker = false

    let availableCurrencies = ["USD", "EUR", "GBP", "TRY", "JPY", "INR"]
    let themes = ["Light", "Dark"]

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
                        ForEach(themes, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }

                Section(header: Text("Budget")) {
                    VStack(alignment: .leading) {
                        Text("Set Monthly Budget: $\(Int(budget))")
                        Slider(value: $budget, in: 100...5000, step: 50)
                    }
                }

                Section(header: Text("Data")) {
                    Button("Export Data to CSV") {
                    }
                    .foregroundColor(.blue)

                    Button("Clear All Data") {
                    }
                    .foregroundColor(.red)
                }

                Section(header: Text("About")) {
                    Button("Help & Support") {

                    }
                    Button("About App") {
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct CurrencyPicker: View {
    @Binding var selectedCurrency: String
    @Environment(\.dismiss) var dismiss

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
            .onChange(of: selectedCurrency) { oldValue, newValue in
                dismiss()
            }
        }
    }
}
#Preview {
    SettingsView()
}
