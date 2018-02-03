//
//  Trade.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 19/01/2018.
//

import Foundation

public struct Trade: Codable {
    var id: Int
    var price: String
    var qty: String
    var time: Int
    var isBuyerMaker: Bool?
    var isBestMatch: Bool
}

public struct MyTrade: Codable {
    var id: Int
    var price: String
    var qty: String
    var time: Int
    var isBestMatch: Bool
    var orderId: Int
    var commission: String
    var commissionAsset: String
    var isBuyer: Bool
    var isMaker: Bool
}
