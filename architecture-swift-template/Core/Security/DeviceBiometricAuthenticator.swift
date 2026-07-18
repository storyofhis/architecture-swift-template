//
//  DeviceBiometricAuthenticator.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import LocalAuthentication

final class DeviceBiometricAuthenticator: BiometricAuthenticating {

    func biometryType() -> LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }

    func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw error ?? LAError(.biometryNotAvailable)
        }

        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluationError in
                if let evaluationError {
                    continuation.resume(throwing: evaluationError)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
