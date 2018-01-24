import Foundation
import XCTest
import BinanceAPI

class BinanceAPITests: XCTestCase {

    let api = BinanceAPI(key: "key", secret: "secret")

    func testPing() {
        let exp = XCTestExpectation(description: "Pinged")

        api.ping(success: {
            exp.fulfill()
        }, failure: nil)

        wait(for: [exp], timeout: 5)
    }

    func testTime() {
        let exp = XCTestExpectation(description: "Loaded time")
        var time: Int = 0

        api.time(success: { st in
            exp.fulfill()
            time = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertTrue(time > 0, "Time not loaded correctly")
    }

    func testExchangeInfo() {
        let exp = XCTestExpectation(description: "Loaded exchangeInfo")
        var info: ExchangeInfo?

        api.exchangeInfo(success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Exchange Info not loaded")
    }

    func testDepth() {
        let symbol = "ETHUSDT"
        let limit = 5
        let exp = XCTestExpectation(description: "Loaded market depth")
        var info: MarketDepth?

        api.depth(symbol: symbol, limit: limit, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Market depth not loaded")
        XCTAssertEqual(info?.bids.count, limit)
    }

    func testTrades() {
        let symbol = "ETHUSDT"
        let limit = 5
        let exp = XCTestExpectation(description: "Loaded last trades")
        var info: [Trade]?

        api.trades(symbol: symbol, limit: limit, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Last trades not loaded")
        XCTAssertEqual(info?.count, limit)
    }

    func testHistoricalTrades() {
        let symbol = "ETHUSDT"
        let limit = 5
        let exp = XCTestExpectation(description: "Loaded historical trades")
        var info: [Trade]?

        api.historicalTrades(symbol: symbol, limit: limit, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Historical trades not loaded")
        XCTAssertEqual(info?.count, limit)
    }

    func testAggregatedTrades() {
        let symbol = "ETHUSDT"
        let limit = 5
        let exp = XCTestExpectation(description: "Loaded aggregated trades")
        var info: [AggregatedTrade]?

        api.aggregatedTrades(symbol: symbol, limit: limit, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Aggregated trades not loaded")
        XCTAssertEqual(info?.count, limit)
    }

    func testCandlesticks() {
        let symbol = "ETHUSDT"
        let limit = 5
        let exp = XCTestExpectation(description: "Loaded candlesticks")
        var info: [Candlestick]?

        api.candlesticks(symbol: symbol, limit: limit, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Candlesticks data not loaded")
        XCTAssertEqual(info?.count, limit)
    }

    func testTickerChange() {
        let symbol = "ETHUSDT"
        let exp = XCTestExpectation(description: "Loaded ticker change")
        var info: TickerPriceChange?

        api.tickerChange(symbol: symbol, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Ticker change not loaded")
    }

    func testTickerPrice() {
        let symbol = "ETHUSDT"
        let exp = XCTestExpectation(description: "Loaded ticker price")
        var info: TickerPrice?

        api.tickerPrice(symbol: symbol, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Ticker price not loaded")
    }

    func testBookTicker() {
        let symbol = "ETHUSDT"
        let exp = XCTestExpectation(description: "Loaded book ticker")
        var info: BookTicker?

        api.bookTicker(symbol: symbol, success: { st in
            exp.fulfill()
            info = st
        }, failure: nil)

        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(info, "Book ticker not loaded")
    }


}
