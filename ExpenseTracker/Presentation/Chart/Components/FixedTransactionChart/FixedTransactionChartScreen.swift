//
//  FixedTransactionChartScreen.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.10.2025.
//

import Charts
import SwiftData
import SwiftUI

struct FixedTransactionChartScreen: View {
    @State private var viewModel: FixedTransactionChartViewModel
    
    @Query(FixedTransaction.getAll) var transactions: [FixedTransaction]
    
    init(selectedRange: DateRangeOption = .month) {
        _viewModel = State(initialValue: FixedTransactionChartViewModel(
            selectedRange: selectedRange
        ))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DateRangePickerView(selectedRange: $viewModel.selectedRange)
            titleView
            
            if viewModel.isChartDataEmpty {
                ContentUnavailableView(
                    "No Projections",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("There are no scheduled expenses for the selected range.")
                )
                .padding()
                .transition(.opacity)
            } else {
                let granularity = viewModel.selectedRange.calendarComponent
                
                Chart(viewModel.chartData) { data in
                    LineMark(
                        x: .value("Date", data.date, unit: granularity),
                        y: .value("Expense", data.amount)
                    )
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", data.date, unit: granularity),
                        y: .value("Expense", data.amount)
                    )
                    .opacity(data.amount == 0 ? 0 : 1)
                    
                    if let selectedData = viewModel.selectedData {
                        RuleMark(x: .value("Selected", selectedData.date, unit: granularity))
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .offset(yStart: -10)
                            .zIndex(-1)
                            .annotation(
                                position: .top, spacing: 0,
                                overflowResolution: .init(x: .fit(to: .chart), y: .disabled)
                            ) {
                                AnnotationView(
                                    date: selectedData.date,
                                    amount: selectedData.amount,
                                    selectedRange: viewModel.selectedRange
                                )
                            }
                    }
                }
                .foregroundStyle(.blue.gradient)
                .chartXAxis {
                    if granularity == .month {
                        AxisMarks(values: .stride(by: .month)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                        }
                    }
                }
                .chartXSelection(value: $viewModel.rawSelectedDate)
            }
        }
        .padding()
        .frame(alignment: .top)
        .animation(.easeInOut, value: viewModel.selectedRange)
        .animation(.easeInOut, value: viewModel.rawSelectedDate)
        .onChange(of: transactions, initial: true) {
            viewModel.transactions = transactions
        }
    }
    
    private var titleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Projected totals")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text("Projections for")
                    Text(viewModel.selectedRange.rawValue.replacingOccurrences(of: "Last", with: "Next"))
                        .bold()
                        .id(viewModel.selectedRange)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .animation(.smooth(duration: 0.3), value: viewModel.selectedRange)
                }
                .font(.title2)
                
                Text("Charts show projected totals based on your fixed transactions.")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .italic()
            }
            .opacity(viewModel.rawSelectedDate == nil ? 1 : 0)
        }
    }
}
