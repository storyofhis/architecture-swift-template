//
//  ComponentsGalleryView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct ComponentsGalleryView: View {

    let container: AppContainer

    var body: some View {
        List(UIComponentDemo.allCases) { demo in
            NavigationLink(value: demo) {
                Label(demo.title, systemImage: demo.systemImage)
            }
        }
        .navigationTitle("UI Components")
        .navigationDestination(for: UIComponentDemo.self) { demo in
            demo.destination(container: container)
                .toolbarVisibility(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    NavigationStack {
        ComponentsGalleryView(container: AppContainer())
    }
}
