//
//  Service.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 19/05/26.
//

import Foundation

struct GetTickerRequest: APIRequest {

    typealias Response = TickerResponse
    typealias Body = EmptyBody

    var method: HTTPMethod = .get

    var url: URL? {
        URL(string: "https://indodax.com/api/ticker_all")
    }

    var query: [String : String]? = nil

    var body: EmptyBody? = nil
}

struct GetServerTimeRequest: APIRequest {

    typealias Response = TimeResponse
    typealias Body = EmptyBody

    var method: HTTPMethod = .get

    var url: URL? {
        URL(string: "https://indodax.com/api/server_time")
    }

    var query: [String : String]? = nil

    var body: EmptyBody? = nil
}

