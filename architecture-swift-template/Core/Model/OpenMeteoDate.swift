//
//  OpenMeteoDate.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import Foundation

/// Open-Meteo timestamps omit seconds and UTC offset, so `Date(_:strategy: .iso8601)` can't parse them.
enum OpenMeteoDate {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
        return formatter
    }()

    static func parse(_ string: String) -> Date? {
        formatter.date(from: string)
    }
}
