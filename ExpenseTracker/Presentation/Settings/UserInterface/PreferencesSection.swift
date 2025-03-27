//
//  PreferencesSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI

struct PreferencesSection: View {
    @Binding var selectedCurrency: String
    @Binding var showCurrencyPicker: Bool
    @Binding var selectedTheme: Appearance

    let availableCurrencies = ["USD", "EUR", "GBP", "TRY", "JPY", "INR"]

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
        }
    }
}
