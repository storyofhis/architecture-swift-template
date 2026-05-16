//
//  APIError.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatusCode(Int)
    case decoding(Error)
    case underlyingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpStatusCode(let code):
            return "HTTP error \(code)"
        case .decoding(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .underlyingError(let error):
            return error.localizedDescription
        }
    }
}
