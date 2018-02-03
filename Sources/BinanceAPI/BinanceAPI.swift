//
//  BinanceAPI.swift
//  BinanceAPI
//
//  Created by Marcin Zbijowski on 17/01/2018.
//

import Foundation

public typealias SuccessCallbackEmpty = () -> Void
public typealias SuccessCallback<T: Codable> = (T) -> Void
public typealias FailureCallback = (Error) -> Void

public enum BinanceAPIError: Error {
    case unexpectedResponseCode(Int)
    case invalidResponse(Data)
}

public enum RequestMethod: String {
    case get = "GET", post = "POST", delete = "DELETE"
}

public class BinanceAPI {

    private let baseUrl = "https://api.binance.com/api/"
    private var key: String
    private var secret: String
    private var decoder = JSONDecoder()

    public init(key: String, secret: String) {
        self.key = key
        self.secret = secret
    }

    class var timestamp: Int {
        let nonce = Int(Date().timeIntervalSince1970 * 1000)
        return nonce
    }

    private func calculateSignature(params: [String: Any]) -> String? {
        let queryString = params.sorted { $0.0 < $1.0 }.map { "\($0.0)=\($0.1)"}.joined(separator: "&")
        return queryString.hmac(secret: self.secret)
    }

    private func request(for endpoint: String, params: [String: Any]) -> URLRequest? {
        let queryString = params.sorted { $0.0 < $1.0 }.map { "\($0.0)=\($0.1)"}.joined(separator: "&")
        let urlStr = self.baseUrl + endpoint + (params.count > 0 ? "?" + queryString : "")
        guard let url = URL(string: urlStr) else { return nil }
        var request = URLRequest(url: url)
        request.addValue(self.key, forHTTPHeaderField: "X-MBX-APIKEY")
        return request
    }

    private func signedRequest(for endpoint: String, method: RequestMethod, params: [String: Any]) -> URLRequest? {
        var params = params
        params["timestamp"] = BinanceAPI.timestamp
        var queryString = params.sorted { $0.0 < $1.0 }.map { "\($0.0)=\($0.1)"}.joined(separator: "&")
        guard let signature = self.calculateSignature(params: params) else { return nil }
        queryString += "&signature=\(signature)"
        let urlStr = self.baseUrl + endpoint + (method == .get ? "?\(queryString)" : "")
        guard let url = URL(string: urlStr) else { return nil }
        print(#function, #line, "⇨", url)
        print(#function, #line, "⇨", queryString)
        var request = URLRequest(url: url)
        request.addValue(self.key, forHTTPHeaderField: "X-MBX-APIKEY")
        request.httpMethod = method.rawValue
        switch method {
        case .post, .delete:
            request.httpBody = queryString.data(using: .utf8)
        default:
            break
        }
        return request
    }

    private func runRequest<T: Codable>(request: URLRequest, success: SuccessCallback<T>? = nil, failure: FailureCallback? = nil) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print(#function, #line, "⇨", String(data: data, encoding: .utf8))
            print(#function, #line, "⇨", (response as? HTTPURLResponse)?.statusCode)
            do {
                let obj = try self.decoder.decode(T.self, from: data)
                success?(obj)
            } catch let err {
                print(#function, err)
                failure?(err)
            }
        }.resume()
    }

    private func runRequest(request: URLRequest, success: SuccessCallbackEmpty? = nil, failure: FailureCallback? = nil) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print(#function, #line, "⇨", String(data: data, encoding: .utf8))
            }
            print(#function, #line, "⇨", (response as? HTTPURLResponse)?.statusCode)
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                success?()
            } else {
                failure?(BinanceAPIError.unexpectedResponseCode(response.statusCode))
            }
        }.resume()
    }

    public class func prepareOrderParams(symbol: String, side: OrderSide, type: OrderType, quantity: Decimal, price: Decimal? = nil) -> [String: Any] {
        var params: [String: Any] = ["symbol": symbol, "side": side.rawValue, "type": type.rawValue, "quantity": quantity]
        params["timestamp"] = BinanceAPI.timestamp
//        params["timeInForce"] = TimeInForce.gtc.rawValue
        params["newOrderRespType"] = OrderResponseType.ack.rawValue
        if let price = price {
            params["price"] = price
        }

        print(#function, #line, "⇨", params)

        return params
    }

    public func ping(success: SuccessCallbackEmpty? = nil, failure: FailureCallback? = nil) {
        guard let request = self.request(for: "v1/ping", params: [:]) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func time(success: SuccessCallback<Int>? = nil, failure: FailureCallback? = nil) {
        guard let request = self.request(for: "v1/time", params: [:]) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let obj = try self.decoder.decode([String: Int].self, from: data)
                if let time = obj["serverTime"] {
                    success?(time)
                } else {
                    failure?(BinanceAPIError.invalidResponse(data))
                }
            } catch let err {
                failure?(err)
            }
        }.resume()
    }

    public func exchangeInfo(success: SuccessCallback<ExchangeInfo>? = nil, failure: FailureCallback? = nil) {
        guard let request = self.request(for: "v1/exchangeInfo", params: [:]) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func depth(symbol: String, limit: Int = 100, success: SuccessCallback<MarketDepth>? = nil, failure: FailureCallback? = nil) {
        guard let request = self.request(for: "v1/depth", params: ["symbol": symbol, "limit": limit]) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func trades(symbol: String, limit: Int = 500, success: SuccessCallback<[Trade]>? = nil, failure: FailureCallback? = nil) {
        guard let request = self.request(for: "v1/trades", params: ["symbol": symbol, "limit": limit]) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func historicalTrades(symbol: String, limit: Int = 500, fromId: Int? = nil, success: SuccessCallback<[Trade]>? = nil, failure: FailureCallback? = nil) {
        var params: [String: Any] = ["symbol": symbol, "limit": limit]
        if let fromId = fromId {
            params["fromId"] = fromId
        }
        guard let request = self.request(for: "v1/historicalTrades", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func aggregatedTrades(symbol: String, limit: Int = 500, fromId: Int? = nil, startTimestamp: Int? = nil, endTimestamp: Int? = nil, success: SuccessCallback<[AggregatedTrade]>? = nil, failure: FailureCallback? = nil) {
        var params: [String: Any] = ["symbol": symbol, "limit": limit]
        if let fromId = fromId {
            params["fromId"] = fromId
        }
        if let startTimestamp = startTimestamp {
            params["startTime"] = startTimestamp
        }
        if let endTimestamp = endTimestamp {
            params["endTime"] = endTimestamp
        }
        guard let request = self.request(for: "v1/aggTrades", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func candlesticks(symbol: String, interval: CandlestickInterval = .hour4, limit: Int = 500, startTimestamp: Int? = nil, endTimestamp: Int? = nil, success: SuccessCallback<[Candlestick]>? = nil, failure: FailureCallback? = nil) {
        var params: [String: Any] = ["symbol": symbol, "interval": interval.rawValue, "limit": limit]
        if let startTimestamp = startTimestamp {
            params["startTime"] = startTimestamp
        }
        if let endTimestamp = endTimestamp {
            params["endTime"] = endTimestamp
        }
        guard let request = self.request(for: "v1/klines", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func tickerChange(symbol: String, success: SuccessCallback<TickerPriceChange>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = ["symbol": symbol]
        guard let request = self.request(for: "v1/ticker/24hr", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func tickerChange(success: SuccessCallback<[TickerPriceChange]>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = [:]
        guard let request = self.request(for: "v1/ticker/24hr", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func tickerPrice(symbol: String, success: SuccessCallback<TickerPrice>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = ["symbol": symbol]
        guard let request = self.request(for: "v3/ticker/price", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func tickerPrice(success: SuccessCallback<[TickerPrice]>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = [:]
        guard let request = self.request(for: "v3/ticker/price", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func bookTicker(symbol: String, success: SuccessCallback<BookTicker>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = ["symbol": symbol]
        guard let request = self.request(for: "v3/ticker/bookTicker", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func bookTicker(success: SuccessCallback<[BookTicker]>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = [:]
        guard let request = self.request(for: "v3/ticker/bookTicker", params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func placeTestOrder(params: [String: Any], success: SuccessCallbackEmpty? = nil, failure: FailureCallback? = nil) {
        guard let request = self.signedRequest(for: "v3/order/test", method: .post, params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func placeOrder(params: [String: Any], success: SuccessCallback<OrderResponse>? = nil, failure: FailureCallback? = nil) {
        guard let request = self.signedRequest(for: "v3/order", method: .post, params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func getOrder(symbol: String, orderId: Int, success: SuccessCallback<Order>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = ["symbol": symbol, "orderId": orderId]
        guard let request = self.signedRequest(for: "v3/order", method: .get, params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func getOpenedOrders(symbol: String?, success: SuccessCallback<[Order]>? = nil, failure: FailureCallback? = nil) {
        var params: [String: Any] = [:]
        if let symbol = symbol {
            params["symbol"] = symbol
        }
        guard let request = self.signedRequest(for: "v3/openedOrders", method: .get, params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func getAllOrders(symbol: String?, limit: Int = 500, success: SuccessCallback<[Order]>? = nil, failure: FailureCallback? = nil) {
        var params: [String: Any] = ["limit": limit]
        if let symbol = symbol {
            params["symbol"] = symbol
        }
        guard let request = self.signedRequest(for: "v3/allOrders", method: .get, params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func cancelOrder(symbol: String, orderId: Int, success: SuccessCallback<CancelledOrder>? = nil, failure: FailureCallback? = nil) {
        let params: [String: Any] = ["symbol": symbol, "orderId": orderId]
        guard let request = self.signedRequest(for: "v3/order", method: .delete, params: params) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func account(success: SuccessCallback<Account>? = nil, failure: FailureCallback? = nil) {
        guard let request = self.signedRequest(for: "v3/account", method: .get, params: [:]) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

    public func account(symbol: String, limit: Int, success: SuccessCallback<[MyTrade]>? = nil, failure: FailureCallback? = nil) {
        guard let request = self.signedRequest(for: "v3/myTrades", method: .get, params: ["symbol": symbol, "limit": limit]) else { return }
        runRequest(request: request, success: success, failure: failure)
    }

}
