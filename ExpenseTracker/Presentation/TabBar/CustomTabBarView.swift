import SwiftUI
import SwiftData

struct CustomTabBarView: View {
    @State private var selectedTab: Tabs = .add
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                HomeView()
            }

            Tab("Category", systemImage: "square.grid.2x2", value: .category) {
                NavigationStack {
                    CategoriesView()
                }
            }

            Tab("", image: "plus.circle.fill", value: .add) {
                    AddExpenseView()
            }

            Tab("Chart", systemImage: "chart.pie", value: .chart) {
                TransactionChartSwitcherView()
            }

            Tab("Settings", systemImage: "gear", value: .profile) {
                NavigationStack{
                    SettingsView()
                }
            }
        }
        .tint(.blue)
    }
}
