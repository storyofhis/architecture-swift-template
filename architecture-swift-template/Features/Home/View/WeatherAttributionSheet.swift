//
//  WeatherAttributionSheet.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

struct WeatherAttributionSheet: View {

    let location: WeatherLocation
    let current: CurrentWeather

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Weather Data") {
                    LabeledContent("Location", value: "\(location.name), \(location.country)")

                    LabeledContent("Last Updated") {
                        Text(current.time, format: .dateTime.hour().minute())
                    }
                }

                Section {
                    Text("Weather data provided by Open-Meteo.com")
                        .typography(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Weather Conditions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    WeatherAttributionSheet(
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
