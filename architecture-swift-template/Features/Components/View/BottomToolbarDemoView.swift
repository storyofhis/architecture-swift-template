//
//  BottomToolbarDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct BottomToolbarDemoView: View {

    @State private var lastAction = "None"

    var body: some View {
        List {
            Section {
                ForEach(1...20, id: \.self) { row in
                    Text("Row \(row)")
                }
            } footer: {
                Text("Last Action: \(lastAction)")
                    .typography(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Toolbars — Bottom")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("New Folder", systemImage: "folder.badge.plus") {
                    lastAction = "New Folder"
                }

                Button("Sort", systemImage: "arrow.up.arrow.down") {
                    lastAction = "Sort"
                }
            }

            ToolbarSpacer(.fixed, placement: .bottomBar)

            ToolbarItem(placement: .bottomBar) {
                Button("Add", systemImage: "plus") {
                    lastAction = "Add"
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BottomToolbarDemoView()
    }
}
