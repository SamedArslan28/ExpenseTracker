//
//  AnnotationView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/21/25.
//

import SwiftUI

struct AnnotationView: View {
    @AppStorage("selectedCurrency") var selectedCurrency: String = Locale.current.currencySymbol ?? "$"

    let date: Date
    let amount: Double
    let selectedRange: DateRangeOption

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 6) {
                Text(formattedDate)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(amount, specifier: "%.2f") \(selectedCurrency)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = selectedRange.dateFormat
        return formatter.string(from: date)
    }
}
