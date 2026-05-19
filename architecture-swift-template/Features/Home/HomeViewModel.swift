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
    @Published var serverTime: String = "-"
    
    
    init(container: AppContainer) {
        self.container = container
        load()
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
    
    func fetchAPI() {
        
        guard let url = URL(string: "https://indodax.com/api/server_time") else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        container.api.fetch(from: url) { [weak self] (result: Result<TimeResponse, Error>) in
            
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch result {
                    
                case .success(let response):

                    let timestamp = Double(response.server_time) ?? 0

                    let date = Date(timeIntervalSince1970: timestamp / 1000)

                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone(secondsFromGMT: 7 * 3600)
                    formatter.dateFormat = "dd MMM yyyy HH:mm:ss"

                    self.serverTime = formatter.string(from: date)
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getAPI() {
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
