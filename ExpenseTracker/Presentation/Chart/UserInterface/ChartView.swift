import Charts
import SwiftUI

struct ChartView: View {
    @State private var myList: [TransactionItem] = [
        .init(name: "Coffee", category: .coffee, amount: 500.0, isExpense: true, date: .now),
        .init(name: "Groceries", category: .food, amount: 45.0, isExpense: true, date: .now),
        .init(name: "Salary", category: .travel, amount: 2000.0, isExpense: true, date: .now),
        .init(name: "Gym Membership", category: .other, amount: 30.0, isExpense: true, date: .now),
        .init(name: "Electricity Bill", category: .shopping, amount: 60.0, isExpense: true, date: .now),
        .init(name: "Freelance Project", category: .coffee, amount: 500.0, isExpense: true, date: .now),
        .init(name: "Streaming Subscription", category: .coffee, amount: 15.0, isExpense: true, date: .now),
        .init(name: "Transport", category: .travel, amount: 25.0, isExpense: true, date: .now)
    ]

    var totalExpense: Double {
          myList.filter { $0.isExpense }.reduce(0) { $0 + $1.amount }
      }
    @State private var groupedTransactions: [(key: TransactionCategory, value: Double)] = []
    @State private var isAnimated: Bool = false

    var body: some View {
        VStack {
            Chart(groupedTransactions, id: \.key) { (category, totalAmount) in
                SectorMark(
                    angle: .value("Category", totalAmount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .foregroundStyle(category.color)
                .cornerRadius(4)
            }
            .chartForegroundStyleScale([
                TransactionCategory.coffee.rawValue: TransactionCategory.coffee.color,
                TransactionCategory.food.rawValue: Color.purple,
                TransactionCategory.shopping.rawValue: Color.yellow,
                TransactionCategory.travel.rawValue: Color.blue,
                TransactionCategory.other.rawValue: Color.gray
            ])
            .padding()
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text("Total Expenses")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("$\(totalExpense, specifier: "%.2f")")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12,
                             style: .continuous)
                .fill(.thickMaterial)
        )
        .frame(height: 300)
        .padding()
        Spacer()
            .onAppear {
                updateGroupedTransactions()
                updateChart()
            }
    }

    private func updateGroupedTransactions() {
        groupedTransactions = Dictionary(grouping: myList, by: { $0.category })
            .map { (key: $0.key, value: $0.value.reduce(0) { $0 + $1.amount }) }
    }

    private func updateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        myList.enumerated().forEach { index, _ in
            let delay = Double(index) * 0.004
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.smooth) {
                    updateGroupedTransactions()
                }
            }
        }
    }
}

#Preview {
    ChartView()
}
