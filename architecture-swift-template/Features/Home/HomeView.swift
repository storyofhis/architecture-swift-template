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
            apiSection
            templateStatusSection
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


    private var apiSection: some View {
        Section("API") {

            Text(viewModel.serverTime)
                .typography(.body)

            Text(viewModel.btcPrice)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchAPI()
            viewModel.getAPI()
        }
    }
}
