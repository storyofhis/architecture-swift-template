//
//  WeatherHeroView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

struct WeatherHeroView: View {

    let location: WeatherLocation
    let current: CurrentWeather

    @ScaledMetric(relativeTo: .largeTitle) private var temperatureFontSize: CGFloat = 72

    private var condition: WeatherCondition {
        WeatherCondition(code: current.weatherCode)
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(location.name)
                .font(.title.bold())

            Text(
                Measurement(value: current.temperature, unit: UnitTemperature.celsius),
                format: .measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))
            )
            .font(.system(size: temperatureFontSize, weight: .thin))

            Label(condition.description, systemImage: condition.symbolName)
                .symbolRenderingMode(.multicolor)
                .typography(.body)

            Text("Feels like \(feelsLikeText)")
                .typography(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }

    private var feelsLikeText: String {
        Measurement(value: current.apparentTemperature, unit: UnitTemperature.celsius)
            .formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0))))
    }
}

#Preview {
    WeatherHeroView(
        location: .jakarta,
        current: CurrentWeather(
            time: .now,
            temperature: 29.4,
            apparentTemperature: 32.1,
            weatherCode: 3,
            windSpeed: 8.2,
            humidity: 70
        )
    )
}
