//
//  HomeViewModel.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {

    private let container: AppContainer

    let location: WeatherLocation

    var current: CurrentWeather?
    var hourlyForecast: [HourlyEntry] = []
    var isLoading: Bool = false
    var errorMessage: String?

    init(container: AppContainer, location: WeatherLocation = .jakarta) {
        self.container = container
        self.location = location
    }

    func fetchWeather() async {
        do {
            let response = try await container.api.execute(
                GetWeatherForecastRequest(location: location)
            )

            current = response.current
            hourlyForecast = response.hourly.filter { $0.time >= response.current.time }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
