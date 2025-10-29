Here is the full README.md file, now with the badges you requested, plus a few more related to the technologies we used (iOS 17+, SwiftData, and Swift Charts).

<p align="center">
  <a href="https://developer.apple.com/xcode/swiftui/">
    <img src="https://developer.apple.com/assets/elements/icons/swiftui/swiftui-64x64_2x.png" width="64" alt="SwiftUI"/>
  </a>
  <a href="https://developer.apple.com/swift-data/">
    <img src="https://developer.apple.com/assets/elements/icons/swiftdata/swiftdata-64x64_2x.png" width="64" alt="SwiftData"/>
  </a>
  <a href="https://developer.apple.com/ios/">
    <img src="https://developer.apple.com/assets/elements/icons/ios-ipados-26/ios-ipados-26-96x96_2x.png" width="64" alt="iOS 17"/>
  </a>
  <a href="https://developer.apple.com/xcode/">
    <img src="https://developer.apple.com/assets/elements/icons/xcode/xcode-64x64_2x.png" width="64" alt="Xcode"/>
  </a>
</p>

# ExpenseTracker

An intelligent expense tracking application built with SwiftUI and SwiftData. This app not only tracks your daily income and expenses but also provides a powerful visualization engine to analyze past spending and project future payments.

## ✨ Features

* **Dashboard:** A dynamic main screen showing your all-time current balance, plus a summary of income vs. expenses for the current month.
* **Transaction Logging:** Easily add one-time income or expense transactions.
* **Recurring Transactions:** Set up fixed, recurring transactions (e.g., salary, rent, subscriptions) that repeat daily, weekly, or monthly.
* **Smart Automation:** The app automatically checks for due recurring transactions on launch and adds them to your main ledger.
* **Advanced Charting:** A powerful charting suite with two distinct, interactive line charts. (See details below)
* **Data Persistence:** Uses **SwiftData** for all local data storage.

---

## 📊 Advanced Charting Engine

The app's core visualization feature is its charting engine, which provides two separate, purpose-built line charts. Both are built using the **Swift Charts** framework and follow an **MVVM** architecture for a clean separation of logic and view.

### 1. Historical Expense Chart (`LineChartScreen`)

This chart provides a detailed look at your *past spending habits*.

* **Data Source:** `DefaultTransaction`
* **Purpose:** To analyze where your money has gone.
* **Key Logic (`LineChartViewModel`):**
    * **Filtering:** Users can filter the chart by both date range ("Last 7 Days", "Last 30 Days", "This Year") and by `TransactionCategory`.
    * **Data Processing (Daily):** For "Week" and "Month" views, the view model processes the data to ensure there is a data point for *every single day* in the range. If a day had no expenses, a `0.0` value is inserted. This "zero-padding" ensures the line chart draws a continuous, accurate line instead of just connecting distant points.
    * **Data Processing (Yearly):** For the "Year" view, the view model groups all transactions by month and sums their totals, plotting 12 points for the year.
    * **Interactivity:** Users can scrub the chart to show an annotation with the exact date and total amount for that period.

### 2. Future Projection Chart (`FixedTransactionChartScreen`)

This chart provides a unique look into the *future*, helping you anticipate upcoming scheduled payments.

* **Data Source:** `FixedTransaction`
* **Purpose:** To visualize your *projected* cash flow based on recurring bills and income.
* **Key Logic (`FixedTransactionChartViewModel`):**
    * **Projection Engine:** The view model reads all `FixedTransaction` templates and calculates their future `nextDueDate`s.
    * **Date Range:** Uses a forward-looking date range (e.g., "Next 7 Days", "Next 30 Days", "Next 12 Months").
    * **Data Processing:** It projects all payments that will occur within the selected future range. Like the historical chart, it "zero-pads" all days/months with no scheduled payments to create a continuous line.
    * **Example:** For the "Next 30 Days" view, it calculates a total for all 30 days and plots them, so you can see at a glance that your rent ($800) is due on the 1st and your salary ($2500) arrives on the 15th.
    * **Interactivity:** Allows scrubbing to see the projected totals for any future day or month.

---

## 🏛️ Core App Structure

### Data Models

1.  **`DefaultTransaction` (Model)**
    * Represents a single, completed transaction (an income or an expense).
    * This is the "ledger" of all past events.

2.  **`FixedTransaction` (Model)**
    * Represents a *template* for a recurring transaction (e.g., "Netflix, $15, monthly on the 10th").
    * The app uses these templates to generate future projections and automate payments.

### Main Views

* **`CurrentBalanceView`**: The main dashboard screen.
* **`TransactionsScrollView`**: A list of all past `DefaultTransaction`s.
* **`LineChartScreen`**: The chart view for historical expenses.
* **`FixedTransactionsView`**: A list of all `FixedTransaction` templates.
* **`FixedTransactionChartScreen`**: The chart view for projecting future payments.
* **`AddTransactionView` / `AddFixedTransactionView`**: The modal sheets used to add new transactions.

## ⚙️ How It Works: Automation Logic

The app's "smart" feature is in the `FixedTransactionsView`:

1.  When the view appears, it fetches all `FixedTransaction` templates.
2.  It checks the `nextDueDate` for each template against the current date.
3.  If a transaction is due (or overdue), the app:
    a.  Creates a new `DefaultTransaction` with the correct name, amount, and date.
    b.  Inserts this new transaction into the database.
    c.  Advances the `FixedTransaction`'s `nextDueDate` to the *next* cycle.
4.  This loop repeats until all overdue transactions are "caught up," ensuring you never miss a payment.

## 🔧 Getting Started

1.  Clone this repository.
2.  Open the `.xcodeproj`.
3.  Build and run the project.
