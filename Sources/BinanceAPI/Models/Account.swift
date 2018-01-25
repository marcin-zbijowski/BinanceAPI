//
//  Account.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 25/01/2018.
//

import Foundation

public struct Account: Codable {
    public var makerCommission: Int
    public var takerCommission: Int
    public var buyerCommission: Int
    public var sellerCommission: Int
    public var canTrade: Bool
    public var canWithdraw: Bool
    public var canDeposit: Bool
    public var updateTime: Int
    public var balances: [AccountBalance]
}

public struct AccountBalance: Codable {
    public var asset: String
    public var free: String
    public var locked: String
}
