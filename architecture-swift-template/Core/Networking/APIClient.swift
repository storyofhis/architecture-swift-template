//
//  APIClient.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation

protocol APIRequest {
    
    associatedtype Response: Decodable
    associatedtype Body: Encodable = EmptyBody
    
    var method: HTTPMethod { get }
    var url: URL? { get }
    var query: [String: String]? { get }
    var body: Body? { get }
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
        
        guard var url = request.url else {
            throw APIError.invalidURL
        }
        
        // Query
        if let query = request.query {
            
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: true
            )
            
            components?.queryItems = query.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            guard let finalURL = components?.url else {
                throw APIError.invalidURL
            }
            
            url = finalURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        // Body
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
