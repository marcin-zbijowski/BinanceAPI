//
//  Candlestick.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 20/01/2018.
//

import Foundation

public struct Candlestick: Codable {
    public var openTime: Int
    public var open: String
    public var high: String
    public var low: String
    public var close: String
    public var volume: String
    public var closeTime: Int
    public var quoteAssetVolume: String
    public var trades: Int
    public var takerBuyBaseAssetVolume: String
    public var takerBuyQuoteAssetVolume: String
    public var somethingToIgnore: String

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.openTime = try container.decode(Int.self)
        self.open = try container.decode(String.self)
        self.high = try container.decode(String.self)
        self.low = try container.decode(String.self)
        self.close = try container.decode(String.self)
        self.volume = try container.decode(String.self)
        self.closeTime = try container.decode(Int.self)
        self.quoteAssetVolume = try container.decode(String.self)
        self.trades = try container.decode(Int.self)
        self.takerBuyBaseAssetVolume = try container.decode(String.self)
        self.takerBuyQuoteAssetVolume = try container.decode(String.self)
        self.somethingToIgnore = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.openTime)
        try container.encode(self.open)
        try container.encode(self.high)
        try container.encode(self.low)
        try container.encode(self.close)
        try container.encode(self.volume)
        try container.encode(self.closeTime)
        try container.encode(self.quoteAssetVolume)
        try container.encode(self.trades)
        try container.encode(self.takerBuyBaseAssetVolume)
        try container.encode(self.takerBuyQuoteAssetVolume)
        try container.encode(self.somethingToIgnore)
    }
}

public enum CandlestickInterval: String, Codable {
    case minute1 = "1m"
    case minute3 = "3m"
    case minute5 = "5m"
    case minute15 = "15m"
    case minute30 = "30m"
    case hour1 = "1h"
    case hour2 = "2h"
    case hour4 = "4h"
    case hour6 = "6h"
    case hour8 = "8h"
    case hour12 = "12h"
    case day1 = "1d"
    case day3 = "3d"
    case week1 = "1w"
    case month1 = "1M"
}

