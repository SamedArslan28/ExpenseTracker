import SwiftUI
import SwiftData

struct CustomTabBarView: View {
    @State private var selectedTab: Tabs = .home
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house", value: .home) {
                    HomeView()
                }

                Tab("Category", systemImage: "square.grid.2x2", value: .category) {
                    CategoriesView()
                }

                Tab("", image: "plus.circle.fill", value: .add) {
                    AddTransactionView()
                }
                
                Tab("Chart", systemImage: "chart.pie", value: .chart) {
                    TransactionChartSwitcherView()
                }

                Tab("Settings", systemImage: "gear", value: .profile) {

                    SettingsView()
                }
            }
        }
        .tint(.blue)
    }
}
