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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    category.color.opacity(1),
                    Color.primary.opacity(0.08)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                categoryHeader
                totalsCard
                transactionList
                Spacer()
            }
            .padding()
        
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private var categoryHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(category.color)
                    .frame(width: 70, height: 70)
                
                Image(systemName: category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
            }
            
            Text(category.rawValue.capitalized)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
        .padding(.top)
    }
    
    
    private var totalsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Total Expenses", systemImage: "arrow.down")
                    .foregroundColor(.primary)
                Spacer()
                Text("-\(totals.expenses, format: .currency(code: "USD"))")
                    .font(.headline.bold().monospaced())
                    .foregroundColor(.red)
            }
            
            Divider()
            
            HStack {
                Label("Total Incomes", systemImage: "arrow.up")
                    .foregroundColor(.primary)
                Spacer()
                Text("+\(totals.incomes, format: .currency(code: "USD"))")
                    .font(.headline.bold().monospaced())
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 5, y: 3)
    }
    
    
    private var transactionList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 4)
                LazyVStack(spacing: 12) {
                    if transactions.isEmpty {
                        ContentUnavailableView {
                            Label("No transactions", systemImage: "tray")
                        }
                        .tint(.secondary)
                        .padding(.top, 40)
                    } else {
                        TransactionsScrollView(items: transactions)
                            .offset(y: 20)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

// 5. Refactored TransactionRow
struct TransactionRow: View {
    let transaction: DefaultTransaction
    
    var body: some View {
        // Simplified: No ZStack needed. Apply background to the HStack.
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.name)
                    .font(.headline)
                    .foregroundColor(.primary)
            
                Text(transaction.date.formatted(date: .abbreviated,
                                                time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(transaction.amount, format: .currency(code: "USD"))
                .font(.callout.bold().monospaced()) // Monospaced
                .foregroundColor(transaction.isExpense ? .red : .green)
        }
        .padding() // Just one clean padding
        .background(.thinMaterial) // Consistent material
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


// MARK: - Preview Mock Data & Container

/*
  These are mock models based on your view's code.
  You can replace them with your actual model definitions if they are in this file.
*/


// 3. PREVIEW CONTAINER SETUP
@MainActor
let previewContainer: ModelContainer = {
    do {
        // Use an in-memory configuration
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DefaultTransaction.self, configurations: config)
        
        let context = container.mainContext
        
        // --- FIXED: Parameters now match the init signature ---
        
        // This was the main broken line, now corrected:
        context.insert(DefaultTransaction(
            name: "Groceries", // Was: .now.addingTimeInterval(-86400)
            category: .food, // Was: 55.40
            amount: 55.40, // Was: true
            isExpense: true, // Was: .food
            date: .now.addingTimeInterval(-86400) // Was: .now
        ))
        
        // Corrected the rest to match the init signature (removed 'date:' label, etc.)
        context.insert(DefaultTransaction(
            name: "Dinner Out",
            category: .food,
            amount: 120.00,
            isExpense: true,
            date: .now.addingTimeInterval(-172800)
        ))
        
        context.insert(DefaultTransaction(
            name: "Coffee Shop",
            category: .food,
            amount: 7.25,
            isExpense: true,
            date: .now.addingTimeInterval(-259200)
        ))
        
        // Income Transaction (for the totals card)
        context.insert(DefaultTransaction(
            name: "Side Project",
            category: .food, // Note: This is also 'food', you might want .income
            amount: 300.00,
            isExpense: false,
            date: .now.addingTimeInterval(-300000)
        ))
        
        // Transport Transactions (for the empty preview)
        context.insert(DefaultTransaction(
            name: "Gas",
            category: .transportation,
            amount: 45.00,
            isExpense: true,
            date: .now
        ))
        
        try context.save()
        return container
        
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()

// Main Preview for the CategoryDetailView
#Preview("Category Detail (Food)") {
    NavigationStack {
        CategoryDetailView(category: .food)
    }
    .modelContainer(previewContainer) // Inject the container
    .preferredColorScheme(.dark)
}

// Preview for the Empty State
#Preview("Category Detail (Empty)") {
    NavigationStack {
        // Use a category that only has expenses in the mock data
        CategoryDetailView(category: .coffee)
    }
    .modelContainer(previewContainer)
    .preferredColorScheme(.dark)
}

#Preview("Transaction Row (Expense)") {
    TransactionRow(
        transaction: DefaultTransaction(
            // Corrected: Matched the init signature
            // init(name: String, category: TransactionCategory, amount: Double, isExpense: Bool, date: Date)
            name: "Test Expense",
            category: .entertainment,
            amount: 99.99,
            isExpense: true,
            date: .now
        )
    )
    .padding()
    .background(.black)
}

#Preview("Transaction Row (Income)") {
    TransactionRow(
        transaction: DefaultTransaction(
            // Corrected: Matched the init signature
            name: "Test Income",
            category: .education,
            amount: 1200.00,
            isExpense: false,
            date: .now
        )
    )
    .padding()
    .background(.black)
}
