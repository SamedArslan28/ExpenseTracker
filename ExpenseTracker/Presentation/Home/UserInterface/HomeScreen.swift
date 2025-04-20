import SwiftData
import SwiftUI

struct HomeScreen: View {
    @Query(DefaultTransaction.getAll) var items: [DefaultTransaction]
    
    var body: some View {
        CurrentBalanceView()
        TransactionsScrollView(items: items)
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
