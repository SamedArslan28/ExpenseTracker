import SwiftUI
import SwiftData

struct CustomTabBarView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }

            Tab("Categories", systemImage: "square.grid.2x2") {
                NavigationStack {
                    CategoriesView()
                        .navigationTitle("Categories")
                        .navigationDestination(for: TransactionCategory.self) { category in
                            CategoryDetailView(category: category)
                        }
                }
            }

            Tab("Chart", systemImage: "chart.pie") {
                NavigationStack {
                    TransactionChartSwitcherView()
                }
            }

            Tab("Settings", systemImage: "gear") {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .tint(.blue)
        .tabViewStyle(.sidebarAdaptable)
    }
}
