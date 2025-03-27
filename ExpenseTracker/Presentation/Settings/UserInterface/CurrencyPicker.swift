//
//  CurrencyPicker.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI

struct CurrencyPicker: View {
    @Binding var selectedCurrency: String
    @Environment(\.dismiss) private var dismiss

    let currencies: [String]

    var body: some View {
        NavigationStack {
            List(currencies, id: \.self) { currency in
                Button {
                    selectedCurrency = currency
                    dismiss()
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
        }
    }
}
