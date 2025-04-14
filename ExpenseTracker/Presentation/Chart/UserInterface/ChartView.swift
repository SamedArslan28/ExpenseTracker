import SwiftUI
import SwiftData

struct TransactionChartSwitcherView: View {
    @Query(DefaultTransaction.getAll) private var transactionItems: [DefaultTransaction]
    @Query(FixedTransaction.getAll) private var fixedTransactions: [FixedTransaction]

    @State private var selectedCategory: ChartCategory = .transactions

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Transaction Charts")
                .font(.largeTitle.bold())
                .padding(.horizontal)

            Picker("Category", selection: $selectedCategory) {
                ForEach(ChartCategory.allCases) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 20) {
                    switch selectedCategory {
                    case .transactions:
                        TransactionChartSectionView(title: "Transactions", items: transactionItems)
                    case .fixedTransactions:
                        TransactionChartSectionView(title: "Fixed Transactions", items: fixedTransactions)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

enum ChartCategory: String, CaseIterable, Identifiable {
    case transactions = "Transactions"
    case fixedTransactions = "Fixed Transactions"

    var id: String { rawValue }
}
