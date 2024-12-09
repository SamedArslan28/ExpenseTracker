import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab: Tabs = .home

    enum Tabs: Hashable {
        case home, category, add, chart, profile
    }

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
                    SettingsView()
                }
            }

        .tint(.indigo)
    }
}

struct AddExpenseView: View {
    var body: some View {
        Text("Add Expense View")

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
        CustomTabView()
    }
}
