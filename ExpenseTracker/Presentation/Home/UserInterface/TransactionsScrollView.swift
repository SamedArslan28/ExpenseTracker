import SwiftUI
import SwiftData

struct TransactionsScrollView: View {
    @Environment(\.modelContext) var modelContext
    var items: [DefaultTransaction]

    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var selectedItem: DefaultTransaction?

    var body: some View {
        contentView 
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .sheet(item: $selectedItem) { item in
                EditTransactionView(transaction: item)
            }
    }
    
    // MARK: - ViewBuilder
    
    @ViewBuilder
    private var contentView: some View {
        if items.isEmpty {
            ContentUnavailableView(
                "No Transactions",
                systemImage: "doc.text.magnifyingglass",
                description: Text("You haven't added any transactions yet.")
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(items) { transaction in
                        TransactionItemRow(
                            transaction: transaction,
                            onEditTapped: {
                                withAnimation {
                                    selectedItem = transaction
                                }
                            },
                            onDeleteTapped: {
                                withAnimation(.easeInOut) {
                                    delete(transaction)
                                }
                            }
                        )
                        .padding(.vertical, 4)
                        .visualEffect { content, proxy in
                            let frame: CGRect = proxy.frame(in: .scrollView(axis: .vertical))
                            let distance: CGFloat = min(0, frame.minY)
                            return content
                                .scaleEffect(1 + distance / 700)
                                .offset(y: -distance / 1.25)
                                .blur(radius: -distance / 50)
                        }
                    }
                }
            }
            .offset(y: -20)
        }
    }

    private func delete(_ transaction: DefaultTransaction) {
        modelContext.delete(transaction)
        do {
            try modelContext.save()
        } catch {
            errorMessage = "Failed to delete transaction: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
}

// MARK: - Preview


