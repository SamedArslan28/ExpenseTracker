import SwiftUI

struct TransactionsScrollView: View {
    @State private var viewModel: TransactionsScrollViewModel = .init(dataSource: .shared)

    var body: some View {
        ScrollView(.vertical) {
            ForEach(viewModel.balanceItems) { transaction in
                BalanceItemRow(transaction: transaction)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                    .visualEffect { content, proxy in
                        let frame: CGRect = proxy.frame(in: .scrollView(axis: .vertical))
                        let distance: CGFloat = min(0, frame.minY)
                        return content
                            .scaleEffect(1 + distance / 700)
                            .offset(y: -distance / 1.25)
                            .blur(radius: -distance / 50)
                    }
                // TODO: - Make implementations
                    .contextMenu {
                        Button("Demo") {
                            print("Context Menu works")
                        }
                    }
            }
        }
        .offset(y: -20)
    }
}
