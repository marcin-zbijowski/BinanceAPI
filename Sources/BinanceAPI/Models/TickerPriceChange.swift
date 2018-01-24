//
//  TickerPriceChange.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 20/01/2018.
//

import Foundation

public struct TickerPriceChange: Codable {
    public var symbol: String
    public var priceChange: String
    public var priceChangePercent: String
    public var weightedAvgPrice: String
    public var prevClosePrice: String
    public var lastPrice: String
    public var lastQty: String
    public var bidPrice: String
    public var askPrice: String
    public var openPrice: String
    public var highPrice: String
    public var lowPrice: String
    public var volume: String
    public var quoteVolume: String
    public var openTime: Int
    public var closeTime: Int
    public var firstId: Int
    public var lastId: Int
    public var count: Int
}
