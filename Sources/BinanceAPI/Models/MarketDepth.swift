//
//  MarketDepth.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 18/01/2018.
//

import Foundation

public struct MarketDepth: Codable {
    public var lastUpdateId: Int
    public var bids: [PriceQuantity]
    public var asks: [PriceQuantity]
}

public struct PriceQuantity: Codable {
    public var price: String
    public var quantity: String

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.price = try container.decode(String.self)
        self.quantity = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(price)
        try container.encode(quantity)
        try container.encode([])
    }
}
