//
//  MenusDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct MenusDemoView: View {

    @State private var sortOrder = "Name"
    @State private var lastAction = "None"

    var body: some View {
        VStack(spacing: 24) {
            Text("Sort Order: \(sortOrder)")
                .typography(.body)
                .foregroundStyle(.secondary)

            Menu {
                Button("Name", systemImage: "textformat") { sortOrder = "Name" }
                Button("Date", systemImage: "calendar") { sortOrder = "Date" }
                Button("Size", systemImage: "arrow.up.arrow.down") { sortOrder = "Size" }

                Menu("More") {
                    Button("Kind", systemImage: "tag") { sortOrder = "Kind" }
                    Button("Tags", systemImage: "tag.fill") { sortOrder = "Tags" }
                }
            } label: {
                Label("Sort By", systemImage: "arrow.up.arrow.down.circle")
            }
            .buttonStyle(.glass)

            Menu {
                Button("Duplicate", systemImage: "plus.square.on.square") { lastAction = "Duplicate" }
                Button("Delete", systemImage: "trash", role: .destructive) { lastAction = "Delete" }
            } label: {
                Label("Edit Item", systemImage: "pencil.circle")
            } primaryAction: {
                lastAction = "Primary Tap: Edit"
            }
            .buttonStyle(.glassProminent)

            Text("Last Action: \(lastAction)")
                .typography(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Menus")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MenusDemoView()
    }
}
