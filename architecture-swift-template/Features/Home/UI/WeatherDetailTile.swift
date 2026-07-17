//
//  WeatherDetailTile.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

struct WeatherDetailTile: View {

    let title: String
    let systemImage: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .symbolRenderingMode(.multicolor)
                .typography(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .typography(.title)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }
}

#Preview {
    WeatherDetailTile(title: "Wind", systemImage: "wind", value: "8 km/h")
}
