import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: CategoriesViewModel = CategoriesViewModel(balanceItems: [.init(name: "asdas", category: .coffee, amount: 21321, isExpense: true)])
    @State var search: String = ""

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
            ScrollView {
                ForEach(BalanceCategory.allCases, id: \.self) { category in
                    if let totals = viewModel.categoryTotals[category] {
                        NavigationLink(destination: CategoryDetailView(category: category, totals: totals)) {
                            HStack {
                                Image(category.iconName)
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

struct CategoryDetailView: View {
    let category: BalanceCategory
    let totals: (expenses: Double, incomes: Double)

    var body: some View {
        VStack(spacing: 20) {
            Text(category.rawValue.capitalized)
                .font(.largeTitle)
                .foregroundColor(category.color)

            HStack {
                Text("Total Expenses:")
                Spacer()
                Text("\(totals.expenses, specifier: "%.2f")")
                    .foregroundColor(.red)
            }
            .padding()

            HStack {
                Text("Total Incomes:")
                Spacer()
                Text("\(totals.incomes, specifier: "%.2f")")
                    .foregroundColor(.green)
            }
            .padding()
            Spacer()
        }
        .padding()
        .navigationTitle(category.rawValue.capitalized)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static let mockItems: [BalanceItem] = [
        BalanceItem(name: "Flight", category: .travel, amount: 200.0, isExpense: true),
        BalanceItem(name: "Salary", category: .income, amount: 5000.0, isExpense: false),
        BalanceItem(name: "Groceries", category: .food, amount: 50.0, isExpense: true),
        BalanceItem(name: "Coffee", category: .coffee, amount: 5.0, isExpense: true)
    ]

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
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
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
