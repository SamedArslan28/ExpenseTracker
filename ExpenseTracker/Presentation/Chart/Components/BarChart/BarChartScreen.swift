//
//  BarChart.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftData
import SwiftUI

struct BarChartScreen: View {
    // MARK: - PROPERTIES

    @Query(DefaultTransaction.getAll) var transactions: [DefaultTransaction]
    @State private var selectedCategory: TransactionCategory = .coffee

    let selectedRange: DateRangeOption

    // FIXME: - move this filtering to parent view or screen.

    private var filteredTransactions: [DefaultTransaction] {
            let now = Date()
            let startDate: Date
            let calendar = Calendar.current
            switch selectedRange {
            case .week:
                startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            case .month:
                startDate = calendar.date(byAdding: .day, value: -30, to: now) ?? now
            case .year:
                startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            }

            return transactions.filter {
                $0.category == selectedCategory && $0.date >= startDate
            }
        }


    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CategoryPicker(selectedCategory: $selectedCategory)
            BarChartView(transactions: filteredTransactions)
        }
        .padding()
    }
}



