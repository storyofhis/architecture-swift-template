//
//  GetWeatherForecastRequest.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import Foundation

struct GetWeatherForecastRequest: APIRequest {

    typealias Response = WeatherResponse
    typealias Body = EmptyBody

    var method: HTTPMethod = .get
    var location: WeatherLocation = .jakarta

    var endpoint: Endpoint {
        Endpoint(
            path: "/v1/forecast",
            queryItems: [
                URLQueryItem(name: "latitude", value: String(location.latitude)),
                URLQueryItem(name: "longitude", value: String(location.longitude)),
                URLQueryItem(name: "current", value: "temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m,apparent_temperature"),
                URLQueryItem(name: "hourly", value: "temperature_2m,weather_code"),
                URLQueryItem(name: "forecast_days", value: "2"),
                URLQueryItem(name: "timezone", value: "auto")
            ]
        )
    }

    var body: EmptyBody? = nil
}
