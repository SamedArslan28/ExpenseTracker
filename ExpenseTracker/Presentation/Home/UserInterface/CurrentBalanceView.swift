import SwiftUI
import SwiftData

struct CurrentBalanceView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @State private var showAddTransactionSheet: Bool = false
    
    // 1. Query all transactions
    @Query(DefaultTransaction.getAll) private var transactions: [DefaultTransaction]

    // 2. Calculate all-time total balance
    private var totalBalance: Double {
        transactions.reduce(0) { total, transaction in
            total + (transaction.isExpense ? -transaction.amount : transaction.amount)
        }
    }
    
    // 3. Get transactions just for the current month
    private var currentMonthTransactions: [DefaultTransaction] {
        let calendar = Calendar.current
        let today = Date()
        return transactions.filter {
            calendar.isDate($0.date, equalTo: today, toGranularity: .month) &&
            calendar.isDate($0.date, equalTo: today, toGranularity: .year)
        }
    }
    
    // 4. Calculate monthly income
    private var monthlyIncome: Double {
        currentMonthTransactions
            .filter { !$0.isExpense }
            .reduce(0) { $0 + $1.amount }
    }
    
    // 5. Calculate monthly expenses
    private var monthlyExpenses: Double {
        currentMonthTransactions
            .filter { $0.isExpense }
            .reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showAddTransactionSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.white)
                    }
                }
                Text("Current Balance")
                    .font(.title3)
                    .foregroundStyle(.thinMaterial)
                
                // Now uses the dynamic totalBalance
                Text(totalBalance.formatted(.currency(code: selectedCurrency)))
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                Text(Date().formatted(.dateTime.year().month(.wide)))
                    .foregroundStyle(.white)
                
                HStack {
                    // Now passes the dynamic amounts
                    TransactionsDetailView(isIncome: true, amount: monthlyIncome)
                    Spacer()
                    TransactionsDetailView(isIncome: false, amount: monthlyExpenses)
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            MeshGradient (
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.9, 0.3], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]],
                colors: [
                    .green, .green, .green,
                    .blue, .blue ,.blue,
                    .black, .black, .black
                ]
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showAddTransactionSheet) {
            NavigationStack {
                // This view will automatically get the modelContext
                AddTransactionView()
            }
        }
    }
}
