//
//  ChartListRowView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/20/25.
//

import SwiftUI

struct ChartListRowView: View {
    let chart: ChartType

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: chart.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.accentColor)

            VStack(alignment: .leading) {
                Text(chart.title)
                    .font(.headline)
            }
        }
        .padding(.vertical, 8)
    }
}
