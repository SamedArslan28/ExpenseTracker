import SwiftUI
import SwiftData

struct FixedIncomeView: View {
    @State private var isShowingAddIncomeSheet: Bool = false
//    @State private var viewModel: FixedIncomeViewModel = .init(dataSource: .shared)
    @Environment(\.modelContext) var modelContext
    @Query(FixedTransaction.getAll) private var fixedTransactions: [FixedTransaction]

    var body: some View {
        VStack {
            contentView
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddIncomeSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
//        .sheet(isPresented: $isShowingAddIncomeSheet) { addIncomeSheet }
        .onAppear {
//            viewModel.fetchFixedItems()
        }
        .navigationTitle("Fixed Income")
    }

    // MARK: - ViewBuilder Content
    @ViewBuilder
    private var contentView: some View {
        if fixedTransactions.isEmpty {
            emptyStateView
        } else {
            populatedListView
        }
    }

    // MARK: - Views
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Fixed Incomes",
            systemImage: "tray",
            description: Text("You haven't added any fixed incomes yet. Tap + to add one.")
        )
        .symbolEffect(.wiggle)

    }

    private var populatedListView: some View {
        List {
            ForEach(fixedTransactions, id: \.id) { item in
                incomeItemView(for: item)
           
            }
//            .onDelete(perform: deleteItems)
            .listStyle(.plain)
        }
    }

    private func incomeItemView(for item: FixedTransaction) -> some View {
        HStack {
            Text(item.name)
            Spacer()
            Text("\(item.amount)")
        }
    }

//    private var addIncomeSheet: some View {
////        AddFixedIncomeView(viewModel: $viewModel)
//    }

//    // MARK: - Actions
//    private func deleteItems(at offsets: IndexSet) {
//        for index in offsets {
//            let itemToDelete = viewModel.fixedItems[index]
//            viewModel.deleteItem(itemToDelete)
//        }
//    }
}

#Preview {
    NavigationStack {
        FixedIncomeView()
    }
}
