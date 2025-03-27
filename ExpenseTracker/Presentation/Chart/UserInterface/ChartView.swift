import Charts
import SwiftUI

struct ChartView: View {
    @State private var viewModel = ChartViewModel(dataSource: .shared)

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
                TransactionCategory.food.rawValue: TransactionCategory.food.color,
                TransactionCategory.shopping.rawValue: TransactionCategory.shopping.color,
                TransactionCategory.travel.rawValue: TransactionCategory.travel.color,
                TransactionCategory.other.rawValue: TransactionCategory.other.color
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
                    .position(x: frame.midX,
                              y: frame.midY)
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
        }
    }
}

#Preview {
    ChartView()
}
