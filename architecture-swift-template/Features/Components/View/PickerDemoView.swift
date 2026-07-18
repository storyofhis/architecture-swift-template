//
//  PickerDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct PickerDemoView: View {

    private enum Size: String, CaseIterable, Identifiable {
        case small, medium, large
        var id: String { rawValue }
        var label: String { rawValue.capitalized }
    }

    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]

    @State private var selectedSize: Size = .medium
    @State private var selectedDay = 3
    @State private var selectedColor: Color = .blue

    var body: some View {
        Form {
            Section("Segmented") {
                Picker("Size", selection: $selectedSize) {
                    ForEach(Size.allCases) { size in
                        Text(size.label).tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Wheel") {
                Picker("Day", selection: $selectedDay) {
                    ForEach(1..<32) { day in
                        Text("\(day)").tag(day)
                    }
                }
                .pickerStyle(.wheel)
            }

            Section("Menu") {
                Picker("Size", selection: $selectedSize) {
                    ForEach(Size.allCases) { size in
                        Text(size.label).tag(size)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Palette") {
                Picker("Color", selection: $selectedColor) {
                    ForEach(colors, id: \.self) { color in
                        Circle().fill(color).tag(color)
                    }
                }
                .pickerStyle(.palette)
            }
        }
        .navigationTitle("Picker")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PickerDemoView()
    }
}
