import SwiftUI
import SwiftData

struct TransactionChartSwitcherView: View {
    @Query(DefaultTransaction.getAll) private var transactionItems: [DefaultTransaction]
    @Query(FixedTransaction.getAll) private var fixedTransactions: [FixedTransaction]

    var body: some View {
        ScrollView {
            TransactionChartSectionView(title: "Transactions", items: transactionItems)
            TransactionChartSectionView(title: "Fixed Transactions", items: fixedTransactions)
        }
        .padding(.vertical)
    }
}

enum ChartCategory: String, CaseIterable, Identifiable {
        case transactions = "Transactions"
        case fixedTransactions = "Fixed Transactions"

        var id: String { self.rawValue }
}
