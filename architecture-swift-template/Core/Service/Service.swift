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

    var endpoint = Endpoint(path: "/api/ticker_all")

    var body: EmptyBody? = nil
}

struct GetServerTimeRequest: APIRequest {

    typealias Response = TimeResponse
    typealias Body = EmptyBody

    var method: HTTPMethod = .get

    var endpoint = Endpoint(path: "/api/server_time")

    var body: EmptyBody? = nil
}
