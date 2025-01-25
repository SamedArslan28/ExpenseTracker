import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: CategoriesViewModel = .init(balanceItems: [])
    @State private var search: String = ""

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
            ScrollView {
                ForEach(TransactionCategory.allCases, id: \.self) { category in
                    if let totals = viewModel.categoryTotals[category] {
                        NavigationLink(destination: CategoryDetailView(category: category, totals: totals)) {
                            HStack {
                                Image(category.iconName)
                                    .accessibilityLabel(category.iconName)
                                    .foregroundColor(category.color)
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(category.rawValue.capitalized)
                                        .foregroundStyle(category.color)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static let mockItems: [TransactionItem] = [ ]

    static var previews: some View {
        CategoriesView(viewModel: CategoriesViewModel(balanceItems: mockItems))
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search categories", text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            })
                        }
                    }
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .padding(.horizontal)
                .background(
                    LinearGradient(colors: [.indigo, .purple], startPoint: .top, endPoint: .bottom)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .ignoresSafeArea()
                )
        }
    }
}
