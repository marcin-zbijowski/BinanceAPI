//
//  AggregatedTrade.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 19/01/2018.
//

import Foundation

public struct AggregatedTrade: Codable {

    public var aggregatedTradeId: Int
    public var price: String
    public var quantity: String
    public var firstTradeId: Int
    public var lastTradeId: Int
    public var timestamp: Int
    public var wasBuyerMaker: Bool
    public var wasBestPriceMatch: Bool

    private enum CodingKeys: String, CodingKey {
        case aggregatedTradeId = "a"
        case price = "p"
        case quantity = "q"
        case firstTradeId = "f"
        case lastTradeId = "l"
        case timestamp = "T"
        case wasBuyerMaker = "m"
        case wasBestPriceMatch = "M"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.aggregatedTradeId = try container.decode(Int.self, forKey: .aggregatedTradeId)
        self.price = try container.decode(String.self, forKey: .price)
        self.quantity = try container.decode(String.self, forKey: .quantity)
        self.firstTradeId = try container.decode(Int.self, forKey: .firstTradeId)
        self.lastTradeId = try container.decode(Int.self, forKey: .lastTradeId)
        self.timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.wasBuyerMaker = try container.decode(Bool.self, forKey: .wasBuyerMaker)
        self.wasBestPriceMatch = try container.decode(Bool.self, forKey: .wasBestPriceMatch)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.aggregatedTradeId, forKey: .aggregatedTradeId)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.quantity, forKey: .quantity)
        try container.encode(self.firstTradeId, forKey: .firstTradeId)
        try container.encode(self.lastTradeId, forKey: .lastTradeId)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.wasBuyerMaker, forKey: .wasBuyerMaker)
        try container.encode(self.wasBestPriceMatch, forKey: .wasBestPriceMatch)
    }

}
