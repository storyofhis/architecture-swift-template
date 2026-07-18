//
//  SliderDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct SliderDemoView: View {

    @State private var brightness: Double = 0.6
    @State private var volume: Double = 40
    @State private var isEditingVolume = false

    var body: some View {
        Form {
            Section("Continuous") {
                VStack(alignment: .leading) {
                    Slider(value: $brightness, in: 0...1) {
                        Text("Brightness")
                    } minimumValueLabel: {
                        Image(systemName: "sun.min")
                    } maximumValueLabel: {
                        Image(systemName: "sun.max.fill")
                    }
                    Text("\(Int(brightness * 100))%")
                        .typography(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Stepped, with live feedback") {
                VStack(alignment: .leading) {
                    Slider(
                        value: $volume,
                        in: 0...100,
                        step: 5,
                        onEditingChanged: { editing in isEditingVolume = editing }
                    ) {
                        Text("Volume")
                    }
                    Text(isEditingVolume ? "Adjusting…" : "Volume: \(Int(volume))")
                        .typography(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Slider")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SliderDemoView()
    }
}
