import SwiftUI

struct CategoriesView: View {
    @State var viewModel: CategoriesViewModel = .init(balanceItems: [])
    @State private var search: String = ""

    var body: some View {
        List {
            ForEach(TransactionCategory.allCases, id: \.self) { category in
                NavigationLink(destination: CategoryDetailView(category: category)) {
                    HStack {
                        Image(category.iconName)
                            .resizable()
                            .frame(width: 50,
                                   height: 50)
                            .foregroundColor(category.color)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(category.rawValue.capitalized)

                        }
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Categories")
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static let mockItems: [TransactionItem] = [ ]

    static var previews: some View {
        NavigationStack {
                CategoriesView(viewModel: CategoriesViewModel(balanceItems: mockItems))
            }
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
                        .frame(maxWidth: .infinity, maxHeight: .greatestFiniteMagnitude)
                        .ignoresSafeArea()
                )
        }
    }
}
