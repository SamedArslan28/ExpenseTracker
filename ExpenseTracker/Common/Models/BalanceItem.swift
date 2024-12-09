struct BalanceItem: Identifiable {
    let id: UUID = UUID()
    let name: String
    let category: BalanceCategory
    let amount: Double
    let isExpense: Bool
    let date: Date = .now
}

enum BalanceCategory: String, CaseIterable {
    case travel, food, income, shopping

    var iconName: String {
        switch self {
            case .travel: return "airplane"
            case .food: return "cart"
            case .income: return "creditcard"
            case .shopping: return "bag"
        }
    }
}
