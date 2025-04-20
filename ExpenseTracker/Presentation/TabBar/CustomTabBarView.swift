import SwiftUI
import SwiftData

struct CustomTabBarView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeScreen()
            }

            Tab("Categories", systemImage: "square.grid.2x2") {
                NavigationStack {
                    CategoriesScreen()
                        .navigationTitle("Categories")
                        .navigationDestination(for: TransactionCategory.self) { category in
                            CategoryDetailView(category: category)
                        }
                }
            }

            Tab("Chart", systemImage: "chart.pie") {
                NavigationStack {
                    ChartScreen()
                }
            }

            Tab("Settings", systemImage: "gear") {
                NavigationStack {
                    SettingsScreen()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
