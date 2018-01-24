//
//  ExchangeInfo.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 19/01/2018.
//

import Foundation

public struct ExchangeInfo: Codable {
    public var timezone: String
    public var serverTime: Int
    public var rateLimits: [RateLimit]
}

public enum RateLimitType: String, Codable {
    case requests = "REQUESTS"
    case orders = "ORDERS"
}

public enum RateLimitInterval: String, Codable {
    case second = "SECOND"
    case minute = "MINUTE"
    case day = "DAY"
}

public struct RateLimit: Codable {
    public var rateLimitType: RateLimitType
    public var interval: RateLimitInterval
    public var limit: Int
}
