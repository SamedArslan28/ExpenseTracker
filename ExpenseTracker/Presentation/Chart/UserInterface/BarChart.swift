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
    @State private var rawSelectedBar: Date?
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"

    private var selectedBar: Date? {
        rawSelectedBar
    }

    private let categories = TransactionCategory.allCases.filter { $0 != .fixedExpenses }

    private var filteredTransactions: [DefaultTransaction] {
        transactions.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CategoryPicker(
                selectedCategory: $selectedCategory,
                categories: categories
            )
            ExpenseChartView(
                transactions: filteredTransactions,
                selectedBar: selectedBar,
                rawSelectedBar: $rawSelectedBar,
                currency: selectedCurrency
            )
        }
        .padding(.top)
    }
}

private struct CategoryPicker: View {
    @Binding var selectedCategory: TransactionCategory
    let categories: [TransactionCategory]

    var body: some View {
        HStack {
            Text("Select a Category")
                .font(.headline)
            Spacer()
            Picker("Category", selection: $selectedCategory.animation(.easeInOut)) {
                ForEach(categories, id: \.self) { category in
                    HStack {
                        Image(systemName: category.iconName)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(category.color)
                        Text(category.rawValue.capitalized)
                    }
                }
            }
            .pickerStyle(.menu)
        }
    }
}

private struct ExpenseChartView: View {
    let transactions: [DefaultTransaction]
    let selectedBar: Date?
    @Binding var rawSelectedBar: Date?
    let currency: String
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"

    var body: some View {
        if transactions.isEmpty {
            ContentUnavailableView(
                "No Data Found",
                systemImage: "chart.bar.xaxis",
                description: Text("No expenses found for the selected category.")
            )
            .frame(height: 300)
            .padding()
        } else {
            Chart(transactions) { data in
                BarMark(
                    x: .value("Month", data.date, unit: .month),
                    y: .value("Expense", data.amount)
                )
                .annotation(position: .top ) {
                    Text(data.amount.formatted(.currency(code: selectedCurrency)).description)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.trailing)

                }
                if let selectedBar {
                    RuleMark(x: .value("Selected", selectedBar, unit: .month))
                        .foregroundStyle(.gray.opacity(0.3))
                        .offset(yStart: -10)
                        .zIndex(-1)
                        .annotation(position: .top, spacing: 0) {
                            if let amount = totalForSelectedMonth {
                                Text("\(currency)\(amount, specifier: "%.2f")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                }
            }

            .chartXSelection(value: $rawSelectedBar)
            .chartXVisibleDomain(length: 3600 * 24 * 30 * 12 * -1)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { _ in
                    AxisValueLabel(format: .dateTime.month(.twoDigits), centered: true)
                }
            }
            .frame(height: 300)
            .padding()
            .animation(.smooth, value: selectedBar)
        }
    }

    private var totalForSelectedMonth: Double? {
        guard let selectedBar else { return nil }
        let calendar = Calendar.current
        return transactions
            .filter { calendar.isDate($0.date, equalTo: selectedBar, toGranularity: .month) }
            .map(\.amount)
            .reduce(0, +)
    }
}
