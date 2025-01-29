import SwiftUI

struct FixedIncomeView: View {
    @State private var isShowingAddIncomeSheet: Bool = false
    @State private var viewModel: FixedIncomeViewModel = .init(dataSource: .shared)

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
        .sheet(isPresented: $isShowingAddIncomeSheet) { addIncomeSheet }
        .onAppear { viewModel.fetchFixedItems() }
        .navigationTitle("Fixed Income")
    }

    // MARK: - ViewBuilder Content
    @ViewBuilder
    private var contentView: some View {
        if viewModel.fixedItems.isEmpty {
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
    }

    private var populatedListView: some View {
        List {
            ForEach(viewModel.fixedItems, id: \.id) { item in
                incomeItemView(for: item)
            }
            .onDelete(perform: deleteItems)
        }
    }

    private func incomeItemView(for item: TransactionItem) -> some View {
        HStack {
            Text(item.name)
            Spacer()
            Text("\(item.amount)")
        }
    }

    private var addIncomeSheet: some View {
        AddFixedIncomeView(viewModel: $viewModel)
    }

    // MARK: - Actions
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = viewModel.fixedItems[index]
            viewModel.deleteItem(itemToDelete)
        }
    }
}

#Preview {
    NavigationStack {
        FixedIncomeView()
    }
}
