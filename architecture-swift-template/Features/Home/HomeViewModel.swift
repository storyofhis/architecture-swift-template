//
//  HomeViewModel.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    private let container: AppContainer
    
    @Published var counter: Int = 0
    @Published var note: String = ""
    
/// declare all of those variables that you want to show
    @Published var btcPrice: String = "-"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    
    init(container: AppContainer) {
        self.container = container
        load()
        testAPI()
    }
    
    func increment() {
        counter += 1
        container.log.info("Counter = \(counter)")
        container.store.set(String(counter), forKey: Keys.counter)
    }
    
    func saveNote() {
        container.store.set(note, forKey: Keys.note)
        container.log.info("Saved note")
    }
    
    private func load() {
        if let raw = container.store.string(forKey: Keys.counter),
           let value = Int(raw) {
            counter = value
        }
        note = container.store.string(forKey: Keys.note) ?? ""
    }
    
    func testAPI() {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let response = try await container.api.get(
                    baseURL: URL(string: "https://indodax.com")!,
                    endpoint: Endpoint(path: "/api/ticker_all"),
                    responseType: TickerResponse.self
                )

                if let btc = response.tickers["btc_idr"] {
                    btcPrice = btc.last ?? "-"
                }
                
                isLoading = false
                
                container.log.info("\(response)")

            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
            
            if let errorMessage {
                container.log.error("\(errorMessage)")
            }
        }
        
    }
}

private enum Keys {
    static let counter = "home_counter_v1"
    static let note = "home_note_v1"
}
