import Charts
import SwiftUI

struct ChartView: View {
    @State private var viewModel = ChartViewModel(dataSource: .shared)
    @State private var isAnimated: Bool = false

    var body: some View {
        VStack {
            Chart(viewModel.groupedTransactions, id: \.key) { (category, totalAmount) in
                SectorMark(
                    angle: .value("Category", totalAmount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .foregroundStyle(category.color)
                .cornerRadius(5)
            }
            .chartForegroundStyleScale([
                TransactionCategory.coffee.rawValue: TransactionCategory.coffee.color,
                TransactionCategory.food.rawValue: Color.purple,
                TransactionCategory.shopping.rawValue: Color.yellow,
                TransactionCategory.travel.rawValue: Color.blue,
                TransactionCategory.other.rawValue: Color.gray
            ])
            .chartLegend(alignment: .center, spacing: 18)
            .padding()
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text("Total Expenses")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("$\(viewModel.totalExpense, specifier: "%.2f")")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }

        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.thickMaterial)
        )
        .frame(height: 300)
        .padding()
        Spacer()
        .onAppear {
            viewModel.fetchItems()
            updateChart()
        }
    }

    private func updateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        viewModel.balanceItems.enumerated().forEach { index, _ in
            let delay = Double(index) * 0.0001
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.smooth) {
                    viewModel.updateGroupedTransactions()
                }
            }
        }
        isAnimated = false
    }
}

#Preview {
    ChartView()
}
