import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(DefaultTransaction.getAll) var items: [DefaultTransaction]
    @State private var showAddItemView: Bool = false

    var body: some View {
        CurrentBalanceView()
        TransactionsScrollView(items: items)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddItemView = true
                    } label: {
                        Image(systemName: "plus")
                            .padding(8)
                            .foregroundStyle(.primary)
                            .background(.thickMaterial)
                            .clipShape(.circle)
                            .padding()
                    }
                }
            }
            .sheet(isPresented: $showAddItemView) {
                NavigationStack {
                    AddTransactionView()

                }
            }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
