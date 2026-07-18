//
//  TopToolbarDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct TopToolbarDemoView: View {

    private let allItems = (1...30).map { "Item \($0)" }

    @State private var searchText = ""
    @State private var lastAction = "None"

    private var filteredItems: [String] {
        guard !searchText.isEmpty else { return allItems }
        return allItems.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List(filteredItems, id: \.self) { item in
            Text(item)
        }
        .navigationTitle("Toolbars — Top")
        .toolbarTitleMenu {
            Button("View as List", systemImage: "list.bullet") { lastAction = "View as List" }
            Button("View as Grid", systemImage: "square.grid.2x2") { lastAction = "View as Grid" }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "Search Items")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                    lastAction = "Filter"
                }
            }

            ToolbarItem(placement: .principal) {
                Text("Last: \(lastAction)")
                    .typography(.caption)
                    .foregroundStyle(.secondary)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {
                    lastAction = "Add"
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TopToolbarDemoView()
    }
}
