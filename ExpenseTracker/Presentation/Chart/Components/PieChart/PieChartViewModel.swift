//
//  PieChartViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/23/25.
//


import Foundation
import Observation

@Observable
class PieChartViewModel {
    let transactions: [DefaultTransaction]
    let selectedAngle: Double?
    let dateRange: DateRangeOption

    init(transactions: [DefaultTransaction], selectedAngle: Double?, dateRange: DateRangeOption) {
        self.transactions = transactions
        self.selectedAngle = selectedAngle
        self.dateRange = dateRange
    }

    private var filteredTransactions: [DefaultTransaction] {
        transactions.filter { $0.date >= dateRange.fromDate }
    }

    var groupedData: [(category: TransactionCategory, total: Double)] {
        let grouped = Dictionary(grouping: filteredTransactions, by: { $0.category })
        let mapped = grouped.map { (category, items) in
            (category, items.reduce(0) { $0 + $1.amount })
        }
        return mapped.sorted { $0.1 > $1.1 }.prefix(5).map { $0 }
    }

    var angleRanges: [(category: TransactionCategory, range: Range<Double>)] {
        var cumulative = 0.0
        return groupedData.map { (category, total) in
            let newCumulative = cumulative + total
            let range = cumulative..<newCumulative
            cumulative = newCumulative
            return (category, range)
        }
    }

    var selectedCategory: (category: TransactionCategory, total: Double)? {
        guard let selectedAngle else { return nil }
        for (index, angleRange) in angleRanges.enumerated() {
            if angleRange.range.contains(selectedAngle) {
                return groupedData[index]
            }
        }
        return nil
    }

    var displayedCategory: (category: TransactionCategory, total: Double)? {
        selectedCategory ?? groupedData.first
    }

    var highlightedCategory: TransactionCategory? {
        selectedCategory?.category ?? groupedData.first?.category
    }
}
