//
//  TransactionsDetailView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct TransactionsDetailView: View {
    var isIncome: Bool
    var amount: Double
    
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: isIncome ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .font(.title3)
                    .foregroundStyle(isIncome ? .green : .red)
                Text(isIncome ? "Income" : "Expense")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            Text(amount.formatted(.currency(code: selectedCurrency)))
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
    }
}
