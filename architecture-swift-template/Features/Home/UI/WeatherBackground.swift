//
//  WeatherBackground.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

struct WeatherBackground: View {

    let weatherCode: Int?

    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var gradientColors: [Color] {
        guard let weatherCode else {
            return [.blue, .cyan]
        }

        switch weatherCode {
        case 0:
            return [.blue, .cyan]
        case 1, 2, 3:
            return [.blue, .gray]
        case 45, 48:
            return [.gray, .gray.opacity(0.6)]
        case 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82:
            return [.gray, .blue.opacity(0.7)]
        case 71, 73, 75, 77, 85, 86:
            return [.gray.opacity(0.8), .white.opacity(0.8)]
        case 95, 96, 99:
            return [.black.opacity(0.7), .indigo]
        default:
            return [.blue, .cyan]
        }
    }
}
