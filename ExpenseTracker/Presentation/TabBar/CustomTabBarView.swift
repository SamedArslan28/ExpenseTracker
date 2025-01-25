import SwiftUI

struct CustomTabBarView: View {
    @State private var selectedTab: Tabs = .home

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
                    AddExpenseView()
                }

                Tab("Chart", systemImage: "chart.pie", value: .chart) {
                    ChartView()
                }

                Tab("Settings", systemImage: "gear", value: .profile) {
                    SettingsView()
                }
            }
        }
        .tint(.indigo)
    }
}

struct ChartView: View {
    var body: some View {
        Text("Chart View")
            .navigationTitle("Chart")
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView()
            .previewDevice("iPhone 16 Pro")
    }
}

enum Tabs: Hashable {
    case add
    case category
    case chart
    case home
    case profile
}
