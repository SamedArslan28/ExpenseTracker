//
//  ChartView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.01.2025.
//

import Charts
import SwiftUI

struct ChartView: View {
    private let myList: [TransactionItem] = [
        .init(name: "Coffee", category: .coffee, amount: 5.0, isExpense: true, date: .now),
        .init(name: "Groceries", category: .food, amount: 45.0, isExpense: true, date: .now),
        .init(name: "Salary", category: .food, amount: 2000.0, isExpense: false, date: .now),
        .init(name: "Gym Membership", category: .food, amount: 30.0, isExpense: true, date: .now),
        .init(name: "Electricity Bill", category: .shopping, amount: 60.0, isExpense: true, date: .now),
        .init(name: "Freelance Project", category: .coffee, amount: 500.0, isExpense: false, date: .now),
        .init(name: "Streaming Subscription", category: .travel, amount: 15.0, isExpense: true, date: .now),
        .init(name: "Transport", category: .travel, amount: 25.0, isExpense: true, date: .now)
    ]
    var body: some View {
        Chart(groupedTransactions, id: \.key) { (category, totalAmount) in
            SectorMark(
                angle: .value(category.rawValue, totalAmount),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .foregroundStyle(by: .value("Category",
                                        category.rawValue.capitalized))
            .cornerRadius(4)
        }
        .padding()
    }

    private var groupedTransactions: [(key: TransactionCategory, value: Double)] {
        Dictionary(grouping: myList, by: { $0.category })
            .map { (key: $0.key, value: $0.value.reduce(0) { $0 + $1.amount }) }
    }
 }

#Preview {
    ChartView()
}
