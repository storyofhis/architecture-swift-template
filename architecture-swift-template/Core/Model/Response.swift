//
//  Response.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/05/26.
//

import Foundation

struct WeatherResponse: Decodable, Sendable {
    let current: CurrentWeather
    let hourly: [HourlyEntry]

    private enum CodingKeys: String, CodingKey {
        case current
        case hourly
    }

    private struct HourlyContainer: Decodable {
        let time: [String]
        let temperature: [Double]
        let weatherCode: [Int]

        enum CodingKeys: String, CodingKey {
            case time
            case temperature = "temperature_2m"
            case weatherCode = "weather_code"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        current = try container.decode(CurrentWeather.self, forKey: .current)

        let hourlyContainer = try container.decode(HourlyContainer.self, forKey: .hourly)
        hourly = zip(zip(hourlyContainer.time, hourlyContainer.temperature), hourlyContainer.weatherCode)
            .compactMap { pair, weatherCode in
                let (timeString, temperature) = pair
                guard let time = OpenMeteoDate.parse(timeString) else { return nil }
                return HourlyEntry(time: time, temperature: temperature, weatherCode: weatherCode)
            }
    }
}

struct CurrentWeather: Decodable, Identifiable, Sendable {
    let time: Date
    let temperature: Double
    let apparentTemperature: Double
    let weatherCode: Int
    let windSpeed: Double
    let humidity: Int

    var id: Date { time }

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
        case humidity = "relative_humidity_2m"
    }

    init(
        time: Date,
        temperature: Double,
        apparentTemperature: Double,
        weatherCode: Int,
        windSpeed: Double,
        humidity: Int
    ) {
        self.time = time
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.weatherCode = weatherCode
        self.windSpeed = windSpeed
        self.humidity = humidity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let timeString = try container.decode(String.self, forKey: .time)
        guard let time = OpenMeteoDate.parse(timeString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .time,
                in: container,
                debugDescription: "Expected date in format yyyy-MM-dd'T'HH:mm, got \(timeString)"
            )
        }
        self.time = time

        temperature = try container.decode(Double.self, forKey: .temperature)
        apparentTemperature = try container.decode(Double.self, forKey: .apparentTemperature)
        weatherCode = try container.decode(Int.self, forKey: .weatherCode)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        humidity = try container.decode(Int.self, forKey: .humidity)
    }
}
