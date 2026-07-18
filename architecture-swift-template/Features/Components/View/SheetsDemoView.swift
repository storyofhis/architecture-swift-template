//
//  SheetsDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct SheetsDemoView: View {

    private struct SheetItem: Identifiable {
        let id = UUID()
        let title: String
    }

    @State private var showMediumSheet = false
    @State private var showLargeSheet = false
    @State private var itemSheet: SheetItem?

    var body: some View {
        VStack(spacing: 16) {
            Button("Medium Detent Sheet") { showMediumSheet = true }
                .buttonStyle(.glass)

            Button("Large, Non-Dismissible Sheet") { showLargeSheet = true }
                .buttonStyle(.glass)

            Button("Item-Driven Sheet") {
                itemSheet = SheetItem(title: "Order #1024")
            }
            .buttonStyle(.glass)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Sheets")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showMediumSheet) {
            SheetContent(title: "Medium Sheet")
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showLargeSheet) {
            SheetContent(title: "Large Sheet")
                .presentationDetents([.large])
                .interactiveDismissDisabled()
        }
        .sheet(item: $itemSheet) { item in
            SheetContent(title: item.title)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
    }
}

private struct SheetContent: View {

    let title: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text(title)
                    .typography(.title)
                Text("Presented with presentationDetents and a drag indicator.")
                    .typography(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SheetsDemoView()
    }
}
