//
//  Model.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/05/26.
//

struct TimeResponse: Decodable {
    let server_time: Int
}

struct TickerResponse: Decodable {
    let tickers: [String: Ticker]
}

struct Ticker: Decodable {
    let high: String?
    let low: String?
    let volBtc: String?
    let volIdr: String?
    let last: String?
    let buy: String?
    let sell: String?

    enum CodingKeys: String, CodingKey {
        case high
        case low
        case volBtc = "vol_btc"
        case volIdr = "vol_idr"
        case last
        case buy
        case sell
    }
}
