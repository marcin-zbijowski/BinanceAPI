//
//  BookTicker.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 20/01/2018.
//

import Foundation

public struct BookTicker: Codable {
    public var symbol: String
    public var bidPrice: String
    public var bidQuantity: String
    public var askPrice: String
    public var askQuantity: String

    private enum CodingKeys: String, CodingKey {
        case symbol, bidPrice, bidQuantity = "bidQty", askPrice, askQuantity = "askQty"
    }
}
