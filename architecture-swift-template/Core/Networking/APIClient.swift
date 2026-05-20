//
//  APIClient.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation

enum Environment {
    case development 
    case production
}

enum APIConfig {
    static let environment: Environment = .development
    
    static var baseURL: URL{
        switch environment {
        case .development:
            return URL(string: "https://indodax.com")!
        case .production:
            return URL(string: "https://indodax.com")!
        }
    }
}

protocol APIRequest {

    associatedtype Response: Decodable
    associatedtype Body: Encodable = EmptyBody

    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
    var body: Body? { get }
}

func makeURL<T: APIRequest>(for request: T) -> URL {

    var components = URLComponents(
        url: APIConfig.baseURL.appendingPathComponent(request.endpoint.path),
        resolvingAgainstBaseURL: false
    )!

    if !request.endpoint.queryItems.isEmpty {
        components.queryItems = request.endpoint.queryItems
    }

    return components.url!
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

        let url = makeURL(for: request)

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
