//
//  WeatherCondition.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

/// Maps Open-Meteo's WMO weather codes to a human-readable description and SF Symbol.
struct WeatherCondition {
    let description: String
    let symbolName: String

    init(code: Int) {
        switch code {
        case 0:
            description = "Clear sky"
            symbolName = "sun.max.fill"
        case 1, 2, 3:
            description = "Partly cloudy"
            symbolName = "cloud.sun.fill"
        case 45, 48:
            description = "Foggy"
            symbolName = "cloud.fog.fill"
        case 51, 53, 55, 56, 57:
            description = "Drizzle"
            symbolName = "cloud.drizzle.fill"
        case 61, 63, 65, 66, 67, 80, 81, 82:
            description = "Rain"
            symbolName = "cloud.rain.fill"
        case 71, 73, 75, 77, 85, 86:
            description = "Snow"
            symbolName = "cloud.snow.fill"
        case 95, 96, 99:
            description = "Thunderstorm"
            symbolName = "cloud.bolt.rain.fill"
        default:
            description = "Unknown"
            symbolName = "questionmark.circle"
        }
    }
}
