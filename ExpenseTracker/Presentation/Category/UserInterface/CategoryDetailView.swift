import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    let category: TransactionCategory
    
    @Query var transactions: [DefaultTransaction]
    
    init(category: TransactionCategory) {
        self.category = category
        _transactions = Query(
            filter: #Predicate {
                $0.categoryRawValue == category.rawValue
            },
            sort: [SortDescriptor(\.date, order: .reverse)]
        )
    }
    
    var totals: (expenses: Double, incomes: Double) {
        transactions.reduce(into: (0.0, 0.0)) { result, tx in
            tx.isExpense ? (result.0 += tx.amount) : (result.1 += tx.amount)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            categoryHeader
            totalsCard
            transactionList
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var categoryHeader: some View {
        VStack(spacing: 8) {
            Image(systemName: category.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(category.color)
                .shadow(radius: 5)
            
            Text(category.rawValue.capitalized)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
        .padding(.top)
    }
    
    private var totalsCard: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Total Expenses", systemImage: "arrow.down")
                Spacer()
                Text("-\(totals.expenses, format: .currency(code: "USD"))")
                    .foregroundColor(.red)
            }
            
            HStack {
                Label("Total Incomes", systemImage: "arrow.up")
                Spacer()
                Text("+\(totals.incomes, format: .currency(code: "USD"))")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5)
    }
    
    private var transactionList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                if transactions.isEmpty {
                    ContentUnavailableView("No transactions", systemImage: "tray")
                        .padding(.top, 40)
                } else {
                    ForEach(transactions) { tx in
                        TransactionRow(transaction: tx)
                    }
                }
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: DefaultTransaction
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.ultraThinMaterial)
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.headline)
                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Text(transaction.amount, format: .currency(code: "USD"))
                    .foregroundColor(transaction.isExpense ? .red : .green)
                    .bold()
            }
        }
        .padding(.vertical, 5)
        .padding()
    }
}
