import SwiftUI
import SwiftData

struct CustomTabBarView: View {
    @State private var selectedTab: Tabs = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                HomeScreen()
            }

            Tab("Chart", systemImage: "chart.pie", value: .chart) {
                NavigationStack {
                    ChartScreen()
                }
            }
            
            Tab(value: .category, role: .search) {
                NavigationStack {
                    CategoriesScreen()
                        .navigationTitle("Categories")
                        .navigationDestination(for: TransactionCategory.self) { category in
                            CategoryDetailView(category: category)
                        }
                }
            }

            Tab("Settings", systemImage: "gear", value: .settings) {
                NavigationStack {
                    SettingsScreen()
                }
            }
        }
        
    }
}

#Preview {
    CustomTabBarView()
}
