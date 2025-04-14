import SwiftUI
import SwiftData

struct CustomTabBarView: View {
    @State private var selectedTab: Tabs = .home
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house") }

            NavigationStack {
                CategoriesView()
                    .navigationTitle("Categories")
                    .navigationDestination(for: TransactionCategory.self) { category in
                        CategoryDetailView(category: category)
                    }
            }
            .tabItem { Label("Categories", systemImage: "square.grid.2x2") }


            NavigationView {
                AddTransactionView()
            }
            .tabItem { Label("", image: "plus.circle.fill") }
            .tag(Tabs.add)


            NavigationStack {
                TransactionChartSwitcherView()
            }
            .tabItem { Label("Chart", systemImage: "chart.pie") }

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(.blue)
    }
}
