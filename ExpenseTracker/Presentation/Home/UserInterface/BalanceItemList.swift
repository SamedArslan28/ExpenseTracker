import SwiftUI

struct BalanceItemList: View {
    @State var balanceItems: [BalanceItem] = [
        .init(name: "Fly to Paris", category: .travel, amount: -523, isExpense: true),
        .init(name: "Groceries", category: .food, amount: -179, isExpense: true),
        .init(name: "Salary+Bonus", category: .income, amount: 1265, isExpense: false),
        .init(name: "Coffee", category: .coffee, amount: 1265, isExpense: false),
        .init(name: "Salary+Bonus", category: .other, amount: 1265, isExpense: false),
        .init(name: "Salary+Bonus", category: .food, amount: 1265, isExpense: true),
        .init(name: "Clothes", category: .shopping, amount: -200, isExpense: true)
    ]



    var body: some View {
        ScrollView(.vertical) {
            ForEach(balanceItems) { transaction in
                BalanceItemRow(transaction: transaction)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                    .visualEffect { content, proxy in
                        let frame = proxy.frame(in: .scrollView(axis: .vertical))
                        let distance = min(0, frame.minY)
                        return content
                            .scaleEffect(1 + distance / 700)
                            .offset(y: -distance / 1.25)
                            .blur(radius: -distance / 50)
                    }
            }
        }
        .offset(y: -20)
    }
}

struct BalanceItemRow: View {
    let transaction: BalanceItem
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.ultraThinMaterial)
            HStack {
                Image(transaction.category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .foregroundColor(transaction.category.color)
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.headline)
                    Text(transaction.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(transaction.amount.formatted(.currency(code: selectedCurrency)))
                    .foregroundColor(transaction.isExpense ? .red : .green)
                    .fontWeight(.bold)
            }
            
            .padding(.vertical, 5)
            .padding()

        }
    }
}

#Preview {
    NavigationView {
        BalanceItemList()
    }
}
