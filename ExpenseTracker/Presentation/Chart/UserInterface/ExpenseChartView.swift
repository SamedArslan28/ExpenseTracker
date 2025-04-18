//
//  ExpenseChartView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/18/25.
//

import Charts
import SwiftUI

struct ExpenseChartView: View {
    @State var rawSelectedDate: Date?
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"

    let transactions: [DefaultTransaction]
    var selectedDate: DefaultTransaction? {
        guard let rawSelectedDate else { return nil }
        return transactions.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .month)
        }
    }

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
                .opacity(rawSelectedDate == nil || data.date == selectedDate?.date ?  1.0 : 0.3)
            }
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXVisibleDomain(length: 2)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { _ in
                    AxisValueLabel(format: .dateTime.month(.twoDigits), centered: true)
                }
            }
            .frame(height: 300)
            .padding()
            .animation(.smooth, value: selectedCurrency)
        }
    }
}
