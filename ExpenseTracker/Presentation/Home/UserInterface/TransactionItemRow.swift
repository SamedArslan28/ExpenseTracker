//
//  BalanceItemRow.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct TransactionItemRow: View {
    let transaction: DefaultTransaction
    let onEditTapped: () -> Void
    let onDeleteTapped: () -> Void

    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @AppStorage("is24HourFormat") private var isSelected24HourFormat: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.ultraThinMaterial)
            HStack {
                Image(systemName: transaction.category.iconName)
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
        .contextMenu {
            Button("Edit") {
                onEditTapped()
            }
            Button(role: .destructive) {
                onDeleteTapped()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .transition(.asymmetric(insertion: .opacity,
                                removal: .slide.combined(with: .opacity)))
        .id(transaction.id)
    }

    private func dateText() -> Text {
        var formatStyle = Date.FormatStyle()
            .weekday(.abbreviated)
            .month(.abbreviated)
            .day()
        formatStyle = formatStyle
            .hour(isSelected24HourFormat ? .twoDigits(amPM: .omitted) : .defaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
            .locale(isSelected24HourFormat ? Locale(identifier: "en_GB") : Locale(identifier: "en_US"))

        return Text(transaction.date.formatted(formatStyle))
            .font(.caption)
            .foregroundColor(.gray)
    }
}
