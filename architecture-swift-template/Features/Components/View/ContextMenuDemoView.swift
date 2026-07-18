//
//  ContextMenuDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct ContextMenuDemoView: View {

    @State private var isFavorite = false
    @State private var lastAction = "None"

    var body: some View {
        VStack(spacing: 24) {
            Text("Long-press the card")
                .typography(.body)
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Image(systemName: isFavorite ? "star.fill" : "photo")
                    .font(.system(size: 48))
                    .foregroundStyle(isFavorite ? .yellow : .secondary)

                Text("Sunset Over the Bay")
                    .typography(.button)
            }
            .frame(width: 220, height: 160)
            .glassCard()
            .contextMenu {
                Button(isFavorite ? "Remove Favorite" : "Add Favorite", systemImage: "star") {
                    isFavorite.toggle()
                    lastAction = isFavorite ? "Added Favorite" : "Removed Favorite"
                }

                Button("Share", systemImage: "square.and.arrow.up") {
                    lastAction = "Share"
                }

                Button("Delete", systemImage: "trash", role: .destructive) {
                    lastAction = "Delete"
                }
            } preview: {
                Image(systemName: "photo")
                    .font(.system(size: 80))
                    .frame(width: 240, height: 180)
            }

            Text("Last Action: \(lastAction)")
                .typography(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Context Menu")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ContextMenuDemoView()
    }
}
