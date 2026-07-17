//
//  WeatherDetailGrid.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

struct WeatherDetailGrid: View {

    let current: CurrentWeather

    private var condition: WeatherCondition {
        WeatherCondition(code: current.weatherCode)
    }

    var body: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 16) {
            GridRow {
                WeatherDetailTile(
                    title: "Wind",
                    systemImage: "wind",
                    value: Measurement(value: current.windSpeed, unit: UnitSpeed.kilometersPerHour)
                        .formatted(.measurement(width: .abbreviated, usage: .general))
                )

                WeatherDetailTile(
                    title: "Humidity",
                    systemImage: "humidity.fill",
                    value: "\(current.humidity)%"
                )
            }

            GridRow {
                WeatherDetailTile(
                    title: "Feels Like",
                    systemImage: "thermometer.medium",
                    value: Measurement(value: current.apparentTemperature, unit: UnitTemperature.celsius)
                        .formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0))))
                )

                WeatherDetailTile(
                    title: "Condition",
                    systemImage: condition.symbolName,
                    value: condition.description
                )
            }
        }
    }
}

#Preview {
    WeatherDetailGrid(
        current: CurrentWeather(
            time: .now,
            temperature: 29.4,
            apparentTemperature: 32.1,
            weatherCode: 3,
            windSpeed: 8.2,
            humidity: 70
        )
    )
    .padding()
}
