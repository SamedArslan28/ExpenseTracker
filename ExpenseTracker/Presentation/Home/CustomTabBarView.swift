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
                    .ignoresSafeArea(.all, edges: .top)
            }

            Tab("Category", systemImage: "square.grid.2x2", value: .category) {
                CategoryView()

            }

            Tab("", image: "plus.circle.fill", value: .add) {
                AddExpenseView()
            }

            Tab("Chart", systemImage: "chart.pie", value: .chart) {
                ChartView()
            }

            Tab("Profile", systemImage: "person", value: .profile) {
                ProfileView()
            }
        }
        .tint(.indigo)
    }
}

struct HomeView: View {
    var body: some View {
        Color.red
    }
}

struct CategoryView: View {
    var body: some View {
        Text("Category View")
            .navigationTitle("Category")
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

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .navigationTitle("Profile")
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
