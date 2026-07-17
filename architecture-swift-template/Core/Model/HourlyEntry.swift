//
//  HourlyEntry.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import Foundation

struct HourlyEntry: Identifiable, Sendable {
    let time: Date
    let temperature: Double
    let weatherCode: Int

    var id: Date { time }
}
