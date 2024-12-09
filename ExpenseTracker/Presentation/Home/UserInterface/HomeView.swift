import SwiftUI

struct HomeView: View {
    var body: some View {
        CurrentBalanceView()
        BalanceItemList()
    }
}

#Preview {
    HomeView()
}
