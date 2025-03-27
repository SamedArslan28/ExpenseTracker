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
        .tint(.indigo)
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

struct DemoTip: Tip {
    var title: Text {
        Text("Tip demo")
    }

    var image: Image? {
        Image(systemName: "star.fill")
    }

    var message: Text? {
        Text("This is a demo tip. Falan filan dersin sonra bakarsin isine.")
    }
}
