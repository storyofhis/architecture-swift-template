//
//  WeatherLocation.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

struct WeatherLocation: Sendable {
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double

    static let jakarta = WeatherLocation(
        name: "Jakarta",
        country: "Indonesia",
        latitude: -6.2088,
        longitude: 106.8456
    )
}
