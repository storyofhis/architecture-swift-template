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
    
    
    private func load() {
        if let raw = container.store.string(forKey: Keys.counter),
           let value = Int(raw) {
            counter = value
        }
        note = container.store.string(forKey: Keys.note) ?? ""
    }
    
    func fetchAPI() {
        
        Task {
            
            do {
                
                let response = try await container.api.execute(
                    GetServerTimeRequest()
                )
                
                let timestamp = Double(response.server_time)
                
                let date = Date(
                    timeIntervalSince1970: timestamp / 1000
                )
                
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone(secondsFromGMT: 7 * 3600)
                formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                
                serverTime = formatter.string(from: date)
                
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func getAPI() {
        
        Task {
            
            do {
                
                let response = try await container.api.execute(
                    GetTickerRequest()
                )
                
                if let btc = response.tickers["btc_idr"] {
                    btcPrice = btc.last ?? "-"
                }
                
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

private enum Keys {
    static let counter = "home_counter_v1"
    static let note = "home_note_v1"
}
