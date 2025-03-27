import SwiftUI
import TipKit

struct CustomTabBarView: View {
    @State private var selectedTab: Tabs = .home

    var body: some View {
        NavigationStack{
            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house", value: .home) {
                    HomeView()
                }

                Tab("Category", systemImage: "square.grid.2x2", value: .category) {
                    NavigationView {
                        CategoriesView()
                    }
                }

                Tab("", image: "plus.circle.fill", value: .add) {
                    NavigationView {
                        AddExpenseView()
                    }
                }

                Tab("Chart", systemImage: "chart.pie", value: .chart) {
                    ChartView()
                }

                Tab("Settings", systemImage: "gear", value: .profile) {
                    SettingsView()
                }
            }
        }
        .tint(.blue)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView()
            .previewDevice("iPhone 16 Pro")
    }
}


