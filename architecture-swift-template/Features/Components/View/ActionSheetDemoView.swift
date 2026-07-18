//
//  ActionSheetDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct ActionSheetDemoView: View {

    @State private var showDialog = false
    @State private var lastChoice = "None"

    var body: some View {
        VStack(spacing: 24) {
            Text("Last Choice: \(lastChoice)")
                .typography(.body)
                .foregroundStyle(.secondary)

            Button("Show Options", systemImage: "ellipsis.circle") {
                showDialog = true
            }
            .buttonStyle(.glassProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Action Sheet")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Photo Options",
            isPresented: $showDialog,
            titleVisibility: .visible
        ) {
            Button("Save to Photos") { lastChoice = "Save to Photos" }
            Button("Copy") { lastChoice = "Copy" }
            Button("Delete", role: .destructive) { lastChoice = "Delete" }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose what to do with this photo.")
        }
    }
}

#Preview {
    NavigationStack {
        ActionSheetDemoView()
    }
}
