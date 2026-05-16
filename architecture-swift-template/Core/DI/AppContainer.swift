//
//  AppContainer.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation

final class AppContainer {
    
    let log: Log.Type
    let store: KeyValueStore
    let api: APIClient
    
    init(
        log: Log.Type = Log.self,
        store: KeyValueStore = UserDefaultStore(),
        api: APIClient = APIClient()
    ) {
        self.log = log
        self.store = store
        self.api = api
    }
}
