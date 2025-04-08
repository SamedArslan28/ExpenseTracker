import SwiftUI
import TipKit

struct CustomTabBarView: View {
    @State private var selectedTab: Tabs = .home

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
                    ChartView()
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
