import SwiftUI

struct CategoriesView: View {
    @State private var searchText: String = ""

    private var filteredCategories: [TransactionCategory] {
        if searchText.isEmpty {
            return TransactionCategory.allCases.sorted(by: { $0.rawValue < $1.rawValue })
        } else {
            return TransactionCategory.allCases.filter {
                $0.rawValue.localizedCaseInsensitiveContains(searchText)
            }
            .sorted(by: { $0.rawValue < $1.rawValue })
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2),
                spacing: 16
            ) {
                ForEach(filteredCategories, id: \.rawValue) { category in
                    NavigationLink(value: category) {
                        CategoryCardView(category: category)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search categories")
        .navigationDestination(for: TransactionCategory.self) { category in
            CategoryDetailView(category: category)
        }
    }
}
