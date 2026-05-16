//
//  ContentView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 15/05/26.
//

import SwiftUI

//RootView 
struct ContentView: View {
    
    let container: AppContainer
    
    var body: some View {
        NavigationStack {
            HomeView(viewModel: HomeViewModel(container: container))
        }
    }
}
