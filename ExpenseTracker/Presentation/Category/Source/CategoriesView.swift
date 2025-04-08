import SwiftUI

struct CategoriesView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2),
                spacing: 16
            ) {
                ForEach(TransactionCategory.allCases, id: \.rawValue) { category in
                    NavigationLink(value: category) {
                        CategoryCardView(category: category)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: TransactionCategory.self) { category in
            CategoryDetailView(category: category)
        }
    }
}
