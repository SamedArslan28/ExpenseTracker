//
//  PreferencesSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI

struct PreferencesSection: View {
    @AppStorage("is24HourFormat") private var isSelected24HourFormat: Bool = true
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @AppStorage("selectedTheme") private var selectedTheme: Appearance = .system
    @State private var showCurrencyPicker: Bool = false

    let availableCurrencies: [String] = ["USD", "EUR", "GBP", "TRY", "JPY", "INR"]

    var body: some View {
        Section(header: Text("Preferences")) {
            HStack {
                Text("Currency")
                Spacer()
                Text(selectedCurrency)
                    .foregroundColor(.gray)
                    .onTapGesture { showCurrencyPicker = true }
                    .sheet(isPresented: $showCurrencyPicker) {
                        CurrencyPicker(selectedCurrency: $selectedCurrency, currencies: availableCurrencies)
                    }
            }
            Picker("Theme", selection: $selectedTheme) {
                ForEach(Appearance.allCases) { appearance in
                    Text(appearance.rawValue.capitalized).tag(appearance)
                }
            }
            Toggle(isOn: $isSelected24HourFormat) {
                Text("Use 24-hour format")
            }

        }
    }
}
