//
//  TickerPrice.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 20/01/2018.
//

import Foundation

public struct TickerPrice: Codable {
    public var symbol: String
    public var price: String
}
