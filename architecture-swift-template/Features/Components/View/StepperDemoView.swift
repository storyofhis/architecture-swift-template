//
//  StepperDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct StepperDemoView: View {

    @State private var guestCount = 2
    @State private var quantity = 1
    @State private var rating = 3

    var body: some View {
        Form {
            Section("Basic") {
                Stepper(value: $guestCount, in: 1...12) {
                    Text("Guests: \(guestCount)")
                }
            }

            Section("Custom Step") {
                Stepper(value: $quantity, in: 0...50, step: 5) {
                    Text("Quantity: \(quantity)")
                }
            }

            Section("Custom Label") {
                Stepper {
                    Label("Rating: \(rating) star\(rating == 1 ? "" : "s")", systemImage: "star.fill")
                } onIncrement: {
                    guard rating < 5 else { return }
                    rating += 1
                } onDecrement: {
                    guard rating > 0 else { return }
                    rating -= 1
                }
            }
        }
        .navigationTitle("Stepper")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StepperDemoView()
    }
}
