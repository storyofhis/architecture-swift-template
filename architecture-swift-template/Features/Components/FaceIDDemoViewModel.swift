//
//  FaceIDDemoViewModel.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import Foundation
import LocalAuthentication
import Observation

@Observable
@MainActor
final class FaceIDDemoViewModel {

    enum Status: Equatable {
        case idle
        case authenticating
        case success
        case failure(String)
    }

    private let container: AppContainer

    var status: Status = .idle

    init(container: AppContainer) {
        self.container = container
    }

    var biometryLabel: String {
        switch container.biometrics.biometryType() {
        case .faceID: "Face ID"
        case .touchID: "Touch ID"
        case .opticID: "Optic ID"
        default: "Biometric Authentication"
        }
    }

    func authenticate() async {
        status = .authenticating

        do {
            let success = try await container.biometrics.authenticate(
                reason: "Authenticate to unlock this demo."
            )
            status = success ? .success : .failure("Authentication was not completed.")
        } catch {
            status = .failure(error.localizedDescription)
        }
    }

    func reset() {
        status = .idle
    }
}
