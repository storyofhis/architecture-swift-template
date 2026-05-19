//
//  APIClient.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation

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
    
    func fetch<T: Decodable>(
        from url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            do {
                let decoded = try self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func get <T: Decodable>(baseURL: URL, endpoint: Endpoint, responseType: T.Type) async throws -> T {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidURL
        }
        
        components.path = endpoint.path
        
        if !endpoint.queryItems.isEmpty{
            components.queryItems = endpoint.queryItems
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.httpStatusCode(http.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
