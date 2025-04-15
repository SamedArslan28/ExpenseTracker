//
//  ExpenseDetailsSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftUI

// TODO: - Clean amount textfield when tapped

struct TransactionDetailsSection: View {
    @Binding var viewModel: AddTransactionViewModel
    @FocusState.Binding  var isInputActive: Bool
    @AppStorage("selectedCurrency") var selectedCurrency: String = Locale.current.currencySymbol ?? "$"

    var body: some View {
        Section("Transaction Details") {
            TextField("Expense Name", text: $viewModel.name)
                .focused($isInputActive)
                .autocapitalization(.words)
                .scrollDismissesKeyboard(.immediately)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
            TextField("Amount (\(selectedCurrency))",
                      value: $viewModel.amount,
                      formatter: amountFormatter)
            .focused($isInputActive)
            .keyboardType(.numberPad)
        }

    }
    private var amountFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = Locale.current.groupingSeparator
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }
}
