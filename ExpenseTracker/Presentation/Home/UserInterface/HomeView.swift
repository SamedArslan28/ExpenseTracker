import SwiftUI

struct HomeView: View {
    var body: some View {
        CurrentBalanceView()
        TransactionsScrollView()
    }
}

#Preview {
    HomeView()
}
