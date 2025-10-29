import SwiftUI
import SwiftData

struct FixedTransactionsView: View {
    @State private var isShowingAddSheet: Bool = false
    @Environment(\.modelContext) var modelContext

    @Query(FixedTransaction.getAll) private var fixedTransactions: [FixedTransaction]

    var body: some View {
        VStack {
            contentView
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddFixedTransactionView()
        }
        .onAppear {
            checkAndProcessDueTransactions()
        }
        .navigationTitle("Fixed Transactions")
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
            "No Fixed Transactions",
            systemImage: "arrow.triangle.2.circlepath",
            description: Text("You haven't added any recurring incomes or expenses yet. Tap + to add one.")
        )
    }

    private var populatedListView: some View {
        List {
            ForEach(fixedTransactions) { item in
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.name)
                            .font(.headline)
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                            .font(.headline)
                            .foregroundStyle(item.isExpense ? .red : .green)
                    }
                    HStack {
                        Text(item.recurrence.rawValue)
                        Spacer()
                        Text("Next due: \(item.nextDueDate.formatted(date: .abbreviated, time: .omitted))")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }

    // MARK: - Actions

    /// This is the core logic engine you requested.
    /// It finds due transactions, creates them, and advances the date.
    private func checkAndProcessDueTransactions() {
        let today = Date()
        // We only check transactions due today or in the past
        let dueTransactions = fixedTransactions.filter { $0.nextDueDate <= today }
        
        for item in dueTransactions {
            // This loop catches up on *all* missed payments.
            // e.g., if the app was closed for 3 months, it will create 3 monthly transactions.
            while item.nextDueDate <= today {
                // 1. Create a new *DefaultTransaction* from the template
                let newTransaction = DefaultTransaction(
                    name: item.name,
                    category: item.category,
                    amount: item.amount,
                    isExpense: item.isExpense,
                    date: item.nextDueDate // The date of the transaction is the day it was due
                )
                
                // 2. Insert the new transaction into the database
                modelContext.insert(newTransaction)
                
                // 3. Advance the fixed transaction to its *next* due date
                item.advanceToNextDueDate()
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = fixedTransactions[index]
            modelContext.delete(itemToDelete)
        }
    }
}

#Preview {
    NavigationStack {
        FixedTransactionsView()
            // Add a mock model container for the preview
            .modelContainer(for: [FixedTransaction.self, DefaultTransaction.self], inMemory: true)
    }
}
