//
//  APIClient.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation

enum AppEnvironment {
    case development
    case production
}

enum APIConfig {
    static let environment: AppEnvironment = .development

    static var baseURL: URL {
        let urlString: String
        switch environment {
        case .development, .production:
            urlString = "https://api.open-meteo.com"
        }

        guard let url = URL(string: urlString) else {
            fatalError("Invalid base URL string: \(urlString)")
        }

        return url
    }
}

protocol APIRequest {

    associatedtype Response: Decodable
    associatedtype Body: Encodable = EmptyBody

    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
    var body: Body? { get }
}

func makeURL<T: APIRequest>(for request: T) throws -> URL {

    guard var components = URLComponents(
        url: APIConfig.baseURL.appendingPathComponent(request.endpoint.path),
        resolvingAgainstBaseURL: false
    ) else {
        throw APIError.invalidURL
    }

    if !request.endpoint.queryItems.isEmpty {
        components.queryItems = request.endpoint.queryItems
    }

    guard let url = components.url else {
        throw APIError.invalidURL
    }

    return url
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


final class APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    func execute<R: APIRequest>(
        _ request: R
    ) async throws -> R.Response {

        let url = try makeURL(for: request)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if let body = request.body {
            urlRequest.httpBody = try JSONEncoder().encode(body)

            urlRequest.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            throw APIError.httpStatusCode(http.statusCode)
        }

        do {
            return try decoder.decode(R.Response.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
