//
//  HomeView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import SwiftUI

struct HomeView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        List {
            templateStatusSection
            localStorageSection
            apiSection
            navigationSection
        }
        .navigationTitle("SwiftUI Template")
    }

    private var templateStatusSection: some View {
        Section("Template status") {
            counterRow

            Button("Increment") {
                viewModel.increment()
            }
            .buttonStyle(.appPrimary())
        }
    }

    private var counterRow: some View {
        HStack {
            Text("Counter")
            Spacer()
            Text("\(viewModel.counter)")
                .monospacedDigit()
        }
    }

    private var localStorageSection: some View {
        Section("Local storage (UserDefaults)") {
            TextField("Write a note…", text: $viewModel.note)

            Button("Save note") {
                viewModel.saveNote()
            }
            .buttonStyle(.appPrimary())
        }
    }

    private var navigationSection: some View {
        Section("Navigation") {
            NavigationLink("Open placeholder screen") {
                placeholderScreen
            }
        }
    }

    private var placeholderScreen: some View {
        Text("Next screen (placeholder)")
            .navigationTitle("Next")
    }

    private var apiSection: some View {
        Section("API") {

            // FETCH API RESULT
            HStack {
                Text("Server Time")

                Spacer()

                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text(viewModel.serverTime)
                        .monospacedDigit()
                }
            }

            // GET API RESULT
            HStack {
                Text("BTC/IDR")

                Spacer()

                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text(viewModel.btcPrice)
                        .monospacedDigit()
                }
            }

            // ERROR
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            // BUTTONS
            VStack(spacing: 12) {

                Button("Fetch Server Time") {
                    viewModel.fetchAPI()
                }

                Button("Get BTC Price") {
                    viewModel.getAPI()
                }
            }
            .buttonStyle(.appPrimary())
        }
    }
}
