//
//  HourlyForecastScroll.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

struct HourlyForecastScroll: View {

    let entries: [HourlyEntry]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(entries) { entry in
                    HourlyForecastTile(entry: entry)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
        .glassCard()
    }
}

#Preview {
    HourlyForecastScroll(
        entries: (0..<12).map { hour in
            HourlyEntry(
                time: Calendar.current.date(byAdding: .hour, value: hour, to: .now) ?? .now,
                temperature: Double(26 + hour % 5),
                weatherCode: [0, 1, 3, 61][hour % 4]
            )
        }
    )
}
