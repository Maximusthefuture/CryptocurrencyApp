//
//  FinhubProvider.swift
//  StockSharesApp
//
//  Created by Maximus on 31.03.2021.
//

import Foundation

class FinhubDataProvider: DataProvider {
    static let queue = DispatchQueue(label: "com.finhub.queue", attributes: .concurrent)
    var session: URLSession
    private let token = "c1165pn48v6t4vgvvivg"
//    private let token = "sandbox_c1165pn48v6t4vgvvj00"
    let group = DispatchGroup()
    var baseUrl = "https://finnhub.io/api/v1/"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func loadPopular<T, E>(completion withCompletion: @escaping (Result<T, E>) -> Void) where T : Codable, E : Error {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "finnhub.io"
        components.path = "/api/v1/index/constituents"
        let queryItemSymbol = URLQueryItem(name: "symbol", value: "^GSPC")
        let queryItemToken = URLQueryItem(name: "token", value: token)
        components.queryItems = [queryItemSymbol, queryItemToken]
        let componentsURL = components.url
        guard let mineURL = componentsURL else  { withCompletion(Result.failure(DataResponseError.network as! E))
            return
        }
        
        let task = session.dataTask(with: mineURL) { (data, response, error) -> Void in
            let status = response as? HTTPURLResponse
            var f = status!.value(forHTTPHeaderField: "x-ratelimit-reset")
            var s = Int(f ?? "0")
            guard let decode = try? JSONDecoder().decode(T.self, from: data!) else {
                var time = TimeInterval(f!)
                let date = NSDate(timeIntervalSince1970: time!)
                print("ratelimit-remaining: \(status!.value(forHTTPHeaderField: "x-ratelimit-remaining"))")
//                print("ratelimit-reset: \(status!.value(forHTTPHeaderField: "x-ratelimit-reset"))")
                print("limit reset: \(date)")
                print("ratelimit-limit \(status!.value(forHTTPHeaderField: "x-ratelimit-limit"))")
                withCompletion(Result.failure(DataResponseError.decoding as! E))
                return
            }
            print("ratelimit-remaining: \(status!.value(forHTTPHeaderField: "x-ratelimit-remaining"))")
            print("ratelimit-reset: \(status!.value(forHTTPHeaderField: "x-ratelimit-reset"))")
            print("ratelimit-limit \(status!.value(forHTTPHeaderField: "x-ratelimit-limit"))")
//
            print(String(describing: status!.statusCode))
            print("URLPopular:\(mineURL.absoluteString)")
            withCompletion(Result.success(decode))
        }
        
        task.resume()
    }
    
    func getSearchResults<T>(query: String, completion withCompletion: @escaping (T?) -> Void) where T : Codable {
        //use loadPopular? then filter
    }
    
    func getDetails<T: Codable, U: Codable>(company: String, completion withCompletion: @escaping (T?, U?) -> Void) {
        let myGroup = DispatchGroup()
        var p: T?
        var q: U?
        if let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(company)&token=\(token)") {
            myGroup.enter()
            let task = session.dataTask(with: url) { (data, response, error) -> Void in
                let decode = try? JSONDecoder().decode(T.self, from: data!)
                let statusCode = response as? HTTPURLResponse
                if statusCode!.hasTooManyRequest {
                    print("429: \(url)")
                }
                print(String(describing: statusCode!.statusCode))
                p = decode
                print("getDetail'P':\(url.absoluteString)")
                myGroup.leave()
            }
            task.resume()
        }
        if  let mineURL = URL(string: "\(baseUrl)quote?symbol=\(company)&token=\(token)") {
            myGroup.enter()
            let task = session.dataTask(with: mineURL) { (data, response, error) -> Void in
                let decode = try? JSONDecoder().decode(U.self, from: data!)
                let statusCode = response as? HTTPURLResponse
                if statusCode!.hasTooManyRequest {
                    print("429: \(mineURL)")
//                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
//                        q = decode
//                        withCompletion(p, q)
//                        print("Q IS \(q)")
//                    }
                }
                q = decode
                print("getDetail'Q':\(mineURL.absoluteString)")
                myGroup.leave()
            }
            task.resume()
        }
        myGroup.notify(queue: FinhubDataProvider.queue) {
            withCompletion(p, q)
        }
    }
}
extension Int {
    var msToSeconds: Double { Double(self) / 1000.0 }
}
