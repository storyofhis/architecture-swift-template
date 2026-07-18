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
        TabView {
            Tab("Weather", systemImage: "cloud.sun.fill") {
                NavigationStack {
                    HomeView(viewModel: HomeViewModel(container: container))
                }
            }

            Tab("Components", systemImage: "square.grid.2x2") {
                NavigationStack {
                    ComponentsGalleryView(container: container)
                }
            }
        }
    }
}
