import SwiftUI
import SwiftData

struct TransactionsScrollView: View {
    @Environment(\.modelContext) var modelContext
    @Query(DefaultTransaction.getAll) var items: [DefaultTransaction]

    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isEditTapped: Bool = false
    @State private var selectedItem: DefaultTransaction?
    var body: some View {
        ScrollView(.vertical) {
            ForEach(items) { transaction in
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
                    .contextMenu {
                        Button("Edit") {
                           isEditTapped = true
                        }
                        Button(role: .destructive) {
                            modelContext.delete(transaction)
                            do {
                                try modelContext.save()
                            } catch {
                                logger.error("Failed to delete transaction: \(error.localizedDescription)")
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .offset(y: -20)
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $isEditTapped) {
            Text("Edit")
        }
    }
}
