//
//  BalanceItemRow.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct BalanceItemRow: View {
    let transaction: TransactionItem
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.ultraThinMaterial)
            HStack {
                Image(transaction.category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .foregroundColor(transaction.category.color)
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.headline)
                    Text(transaction.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
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
}
