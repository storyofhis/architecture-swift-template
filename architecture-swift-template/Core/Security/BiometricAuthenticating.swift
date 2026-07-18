//
//  BiometricAuthenticating.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import LocalAuthentication

protocol BiometricAuthenticating {
    func biometryType() -> LABiometryType
    func authenticate(reason: String) async throws -> Bool
}
