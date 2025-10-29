struct MonthlyExpense: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}