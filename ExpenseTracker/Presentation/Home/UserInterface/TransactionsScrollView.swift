import SwiftUI
import SwiftData

struct TransactionsScrollView: View {
    @Environment(\.modelContext) var modelContext
    var items: [DefaultTransaction]

    @State private var visibleItems: [DefaultTransaction] = []
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isEditTapped: Bool = false
    @State private var selectedItem: DefaultTransaction?

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(visibleItems) { transaction in
                    TransactionItemRow(
                        transaction: transaction,
                        onEditTapped: {
                            selectedItem = transaction
                            isEditTapped = true
                        },
                        onDeleteTapped: {
                            withAnimation(.easeInOut) {
                                delete(transaction)
                            }
                        }
                    )
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
                }
            }
        }
        .onAppear {
            visibleItems = items
        }
        .offset(y: -20)
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $isEditTapped) {
            if let selectedItem {
                Text(selectedItem.id.uuidString)
            }
        }
    }

    private func delete(_ transaction: DefaultTransaction) {
        visibleItems.removeAll { $0.id == transaction.id }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            modelContext.delete(transaction)
            do {
                try modelContext.save()
            } catch {
                errorMessage = "Failed to delete transaction: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
}
