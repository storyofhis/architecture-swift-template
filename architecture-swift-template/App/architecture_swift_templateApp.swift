//
//  architecture_swift_templateApp.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 15/05/26.
//

import SwiftUI

@main
struct architecture_swift_templateApp: App {
    
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
