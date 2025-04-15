import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(DefaultTransaction.getAll) var items: [DefaultTransaction]
    
    var body: some View {
        CurrentBalanceView()
        TransactionsScrollView(items: items)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
