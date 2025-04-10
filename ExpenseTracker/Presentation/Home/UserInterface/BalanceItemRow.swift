//
//  BalanceItemRow.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct BalanceItemRow: View {
    let transaction: DefaultTransaction
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @AppStorage("is24HourFormat") private var isSelected24HourFormat: Bool = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.ultraThinMaterial)
            HStack {
                Image(systemName:transaction.category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .foregroundColor(transaction.category.color)
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.headline)
                    dateText()

                }
                Spacer()
                Text(transaction.amount.formatted(.currency(code: selectedCurrency)))
                    .foregroundColor(transaction.isExpense ? .red : .green)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 5)
            .padding()
        }
    }

    private func dateText() -> Text{
        let baseFormat = Date.FormatStyle()
            .weekday(.abbreviated)
            .month(.abbreviated)
            .day()
            .hour(isSelected24HourFormat ? .twoDigits(amPM: .omitted) : .defaultDigits(amPM: .abbreviated))
            .minute()

        return Text(transaction.date.formatted(baseFormat))
            .font(.caption)
            .foregroundColor(.gray)
    }
}
