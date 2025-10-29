//
//  ExpenseChartView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/18/25.
//

import Charts
import SwiftUI

struct BarChartView: View {
    // MARK: - PROPERTIES

    @State private var rawSelectedDate: Date?
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"

    let transactions: [DefaultTransaction]
    let selectedRange: DateRangeOption

    private var selectedDate: DefaultTransaction? {
        guard let rawSelectedDate else { return nil }
        return transactions.first {
            Calendar.current.isDate($0.date,
                                    equalTo: rawSelectedDate,
                                    toGranularity: selectedRange.calendarComponent)
        }
    }

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading) {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Data Found",
                    systemImage: "chart.bar.xaxis",
                    description: Text("No expenses found for the selected range.")
                )
                .padding()
            } else {
                titleView
                Chart(transactions) { data in
                    BarMark(
                        x: .value("Date", data.date, unit: selectedRange.calendarComponent),
                        y: .value("Expense", data.amount)
                    )
                    .opacity(rawSelectedDate == nil || Calendar.current.isDate(data.date, equalTo: selectedDate?.date ?? Date.distantPast, toGranularity: selectedRange.calendarComponent) ? 1.0 : 0.3)

                    if let selectedDate {
                        RuleMark(
                            x: .value("Selected", selectedDate.date, unit: selectedRange.calendarComponent)
                        )
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .offset(yStart: -10)
                        .zIndex(-1)
                        .annotation(
                            position: .top, spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) {
                            AnnotationView(
                                date: selectedDate.date,
                                amount: selectedDate.amount,
                                selectedRange: selectedRange
                            )
                            .transition(.scale.combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: selectedDate)
                        }
                    }
                }
                .chartYAxis(.hidden)
                .chartXSelection(value: $rawSelectedDate)
                .padding()

            }
        }
    }

    private var titleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total expenses by category")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text("Expenses on")
                    Text(selectedRange.rawValue)
                        .bold()
                        .id(selectedRange)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .animation(.smooth(duration: 0.3), value: selectedRange)
                }
                .font(.title2)

                Text("Charts may appear incomplete if data is missing for some dates.")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .italic()
            }
            .opacity(selectedDate == nil ? 1 : 0)
        }
    }
}

#Preview("Bar Chart With Data") {
    BarChartView(
        transactions: DefaultTransaction.mockTransactions,
        selectedRange: .week
    )
    .padding()
}


// 3. Mock Transaction Data
extension DefaultTransaction {
    static var mockTransactions: [DefaultTransaction] {
        func date(daysAgo: Int = 0, monthsAgo: Int = 0) -> Date {
            let today = Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 29))!
            var dateComponents = DateComponents()
            dateComponents.day = -daysAgo
            dateComponents.month = -monthsAgo
            return Calendar.current.date(byAdding: dateComponents, to: today)!
        }
        
        return [
            // October (Current Month)
            DefaultTransaction(name: "Starbucks", category: .coffee, amount: 5.75, isExpense: true, date: date(daysAgo: 1)), // Oct 28
            DefaultTransaction(name: "Lunch", category: .food, amount: 12.50, isExpense: true, date: date(daysAgo: 1)), // Oct 28
            DefaultTransaction(name: "Local Coffee", category: .coffee, amount: 4.50, isExpense: true, date: date(daysAgo: 4)), // Oct 25
            DefaultTransaction(name: "Bus Fare", category: .coffee, amount: 2.75, isExpense: true, date: date(daysAgo: 5)), // Oct 24
            DefaultTransaction(name: "Dunkin'", category: .coffee, amount: 3.99, isExpense: true, date: date(daysAgo: 7)), // Oct 22
            DefaultTransaction(name: "Groceries", category: .food, amount: 65.20, isExpense: true, date: date(daysAgo: 8)), // Oct 21

            // September
            DefaultTransaction(name: "Cafe Nero", category: .coffee, amount: 6.20, isExpense: true, date: date(daysAgo: 0, monthsAgo: 1)), // Sep 29
            DefaultTransaction(name: "Dinner Out", category: .food, amount: 45.80, isExpense: true, date: date(daysAgo: 5, monthsAgo: 1)), // Sep 24
            DefaultTransaction(name: "Train Ticket", category: .coffee, amount: 14.00, isExpense: true, date: date(daysAgo: 9, monthsAgo: 1)), // Sep 20

            // August
            DefaultTransaction(name: "Peet's Coffee", category: .coffee, amount: 5.25, isExpense: true, date: date(daysAgo: 10, monthsAgo: 2)), // Aug 19
            DefaultTransaction(name: "Takeaway", category: .food, amount: 22.00, isExpense: true, date: date(daysAgo: 15, monthsAgo: 2)), // Aug 14
            
            // February (For "This Year" view)
            DefaultTransaction(name: "Movies", category: .entertainment, amount: 30.00, isExpense: true, date: date(daysAgo: 10, monthsAgo: 8)), // Feb 19
            DefaultTransaction(name: "Coffee", category: .coffee, amount: 4.00, isExpense: true, date: date(daysAgo: 10, monthsAgo: 8)) // Feb 19
        ]
    }
}
