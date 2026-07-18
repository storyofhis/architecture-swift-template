//
//  FaceIDDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct FaceIDDemoView: View {

    @State private var viewModel: FaceIDDemoViewModel

    init(viewModel: FaceIDDemoViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "faceid")
                .font(.system(size: 64))
                .foregroundStyle(.tint)
                .symbolEffect(.pulse, isActive: viewModel.status == .authenticating)

            VStack(spacing: 8) {
                Text(viewModel.biometryLabel)
                    .typography(.title)

                Text(statusMessage)
                    .typography(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Authenticate", systemImage: "faceid") {
                Task { await viewModel.authenticate() }
            }
            .buttonStyle(.glassProminent)
            .disabled(viewModel.status == .authenticating)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassCard()
        .padding()
        .navigationTitle("Face ID")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusMessage: String {
        switch viewModel.status {
        case .idle: "Tap Authenticate to demonstrate biometric login via LocalAuthentication."
        case .authenticating: "Waiting for biometric authentication…"
        case .success: "Authentication succeeded."
        case .failure(let message): message
        }
    }
}

#Preview {
    NavigationStack {
        FaceIDDemoView(viewModel: FaceIDDemoViewModel(container: AppContainer()))
    }
}
