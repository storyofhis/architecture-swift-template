//
//  HourlyForecastTile.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

struct HourlyForecastTile: View {

    let entry: HourlyEntry

    private var condition: WeatherCondition {
        WeatherCondition(code: entry.weatherCode)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.time, format: .dateTime.hour())
                .typography(.caption)

            Image(systemName: condition.symbolName)
                .symbolRenderingMode(.multicolor)
                .font(.title2)

            Text(
                Measurement(value: entry.temperature, unit: UnitTemperature.celsius),
                format: .measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))
            )
            .typography(.body)
        }
    }
}

#Preview {
    HourlyForecastTile(
        entry: HourlyEntry(time: .now, temperature: 28.5, weatherCode: 1)
    )
}
