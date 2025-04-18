//
//  BarChart.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import Charts
import SwiftData
import SwiftUI

struct MonthlyExpense: View {
    @Query(DefaultTransaction.getAll) var transactions: [DefaultTransaction]
    @State private var selectedCategory: TransactionCategory = .coffee

    private var filteredTransactions: [DefaultTransaction] {
        transactions.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CategoryPicker(
                selectedCategory: $selectedCategory,

            )
            ExpenseChartView(
                transactions: filteredTransactions,
            )
        }
        .padding(.top)
    }
}



