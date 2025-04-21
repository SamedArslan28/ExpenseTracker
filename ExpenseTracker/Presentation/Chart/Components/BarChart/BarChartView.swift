//
//  ExpenseChartView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/18/25.
//

import Charts
import SwiftUI

struct BarChartView: View {
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
                                currency: selectedCurrency,
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

#Preview {
    BarChartScreen(selectedRange: .week)
}

