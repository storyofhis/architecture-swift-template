//
//  HomeView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel
    @State private var attributionTarget: CurrentWeather?

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let current = viewModel.current {
                    WeatherHeroView(location: viewModel.location, current: current)

                    if !viewModel.hourlyForecast.isEmpty {
                        HourlyForecastScroll(entries: viewModel.hourlyForecast)
                    }

                    WeatherDetailGrid(current: current)

                    Button("Weather Conditions", systemImage: "info.circle") {
                        attributionTarget = current
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
                    .padding(.top, 8)
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Unable to Load Weather",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                    .padding(.top, 120)
                } else {
                    ProgressView("Loading weather…")
                        .padding(.top, 120)
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .background {
            WeatherBackground(weatherCode: viewModel.current?.weatherCode)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .task {
            await viewModel.fetchWeather()
        }
        .sheet(item: $attributionTarget) { current in
            WeatherAttributionSheet(location: viewModel.location, current: current)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModel(container: AppContainer()))
    }
}
