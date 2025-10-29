import Charts
import SwiftData
import SwiftUI

struct LineChartScreen: View {
    @State private var viewModel: LineChartViewModel
    
    @Query(DefaultTransaction.getAll) var transactions: [DefaultTransaction]
    
    init(selectedRange: DateRangeOption = .week,
         selectedCategory: TransactionCategory = .coffee) {
        _viewModel = State(initialValue: LineChartViewModel(
            selectedRange: selectedRange,
            selectedCategory: selectedCategory
        ))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DateRangePickerView(selectedRange: $viewModel.selectedRange)
            CategoryPicker(selectedCategory: $viewModel.selectedCategory)
            titleView
            
            if viewModel.isChartDataEmpty {
                            ContentUnavailableView(
                                "No Data Found",
                                systemImage: "chart.line.uptrend.xyaxis",
                                description: Text("There is no expense data for the selected range and category.")
                            )
                            .padding()
                            .transition(.opacity)
            } else {
                
                if viewModel.selectedRange == .year {
                    Chart(viewModel.monthlyTotals) { data in
                        LineMark(
                            x: .value("Month", data.date, unit: .month),
                            y: .value("Expense", data.amount)
                        )
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Month", data.date, unit: .month),
                            y: .value("Expense", data.amount)
                        )
                        
                        if let selectedData = viewModel.selectedMonthlyData {
                            RuleMark(x: .value("Selected", selectedData.date, unit: .month))
                                .foregroundStyle(Color.gray.opacity(0.5))
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
                                        date: selectedData.date,
                                        amount: selectedData.amount,
                                        selectedRange: .year
                                    )
                                }
                        }
                    }
                    .foregroundStyle(.blue.gradient)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .month)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                        }
                    }
                    .chartXSelection(value: $viewModel.rawSelectedDate)
                    
                } else {
                    Chart(viewModel.dailyTotals) { transaction in
                        LineMark(
                            x: .value("Date", transaction.date, unit: .day),
                            y: .value("Expense", transaction.amount)
                        )
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Date", transaction.date, unit: .day),
                            y: .value("Expense", transaction.amount)
                        )
                        .opacity(transaction.amount == 0 ? 0 : 1)
                        
                        if let selectedData = viewModel.selectedDailyData {
                            RuleMark(x: .value("Selected", selectedData.date, unit: .day))
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .offset(yStart: -10)
                                .zIndex(-1)
                                .annotation(
                                    position: .top,
                                    alignment: .center,
                                    spacing: 10,
                                    overflowResolution: .init(x: .fit(to: .chart), y: .disabled)
                                ) {
                                    AnnotationView(
                                        date: selectedData.date,
                                        amount: selectedData.amount,
                                        selectedRange: .month
                                    )
                                }
                        }
                    }
                    
                    .foregroundStyle(.blue.gradient)
                    .chartXSelection(value: $viewModel.rawSelectedDate)
                }
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
                Text("Total expenses by category")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text("Expenses on")
                    Text(viewModel.selectedRange.rawValue)
                        .bold()
                        .id(viewModel.selectedRange)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .animation(.smooth(duration: 0.3), value: viewModel.selectedRange)
                }
                .font(.title2)
                
                Text("Charts may appear incomplete if data is missing for some dates.")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .italic()
            }
            .opacity(viewModel.rawSelectedDate == nil ? 1 : 0)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DefaultTransaction.self, configurations: config)
        let context = container.mainContext
        
        let mockData = DefaultTransaction.mockTransactions
        for transaction in mockData {
            context.insert(transaction)
        }
        
        return LineChartScreen(selectedRange: .week)
            .modelContainer(container)
        
    } catch {
        return Text("Failed to create preview container: \(error.localizedDescription)")
    }
}
