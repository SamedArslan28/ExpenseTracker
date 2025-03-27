import SwiftUI

// TODO: - Move categories to expandable list.
// TODO: - Add delete and configure to list items

struct CategoriesView: View {
    @State var viewModel: CategoriesViewModel = .init(balanceItems: [])

    var body: some View {
        NavigationStack {
            categoryFilter(filteredCategories: viewModel.filteredCategories)
                .searchable(text: $viewModel.searchText)
                .navigationTitle("Categories")
                .navigationDestination(for: TransactionCategory.self) { category in
                    CategoryDetailView(category: category)
                }
        }
    }
}

#Preview {
    CategoriesView()
}

@ViewBuilder
func categoryFilter(filteredCategories: [TransactionCategory]) -> some View {
    if filteredCategories.isEmpty {
        ContentUnavailableView("There is no category",
                               systemImage: "tray",
                               description: Text("Search for a category"))
    } else {
        List {
            ForEach(filteredCategories, id: \.self) { category in
                NavigationLink(value: category) {
                    HStack {
                        Image(category.iconName)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(category.color)
                            .font(.largeTitle)

                        VStack(alignment: .leading) {
                            Text(category.rawValue.capitalized)
                        }
                    }
                }
            }
        }
    }
}
