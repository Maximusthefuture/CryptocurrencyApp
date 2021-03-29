//
//  NetworkManager.swift
//
//  Created by Maximus on 09.03.2021.
//

import Foundation
import UIKit


protocol PriceDelegate {
    func didUpdatePrice(price: Double)
}


protocol NetworkManagerProtocol {
    func loadQuotes<T>(completion withCompletion: @escaping (([T?]) -> Void))
    func loadProfile<T>(companyName company: String, competion withCompletion: @escaping (T?) -> Void)
    func loadStockPrice<T>(companyName company: String, completion withCompletion: @escaping (T?) -> Void)
    //Надо?
    func loadImage()
    
}

class NetworkManager {
    
    private let token = "c1165pn48v6t4vgvvivg"
    let group = DispatchGroup()
    var baseUrl = "https://finnhub.io/api/v1/"
    var cache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()
    var delegate: PriceDelegate?
  
    func loadQuotes(completion withCompletion: @escaping ([Quotes]?) -> Void) {
        group.enter()
        let url = URL(string: "https://mboum.com/api/v1/tr/trending?apikey=demo")
        //        let url = URL(string: "\(baseUrl)stock/symbol?exchange=US&token=\(token)")
        //https://finnhub.io/api/v1/quote?symbol=AAPL&token=c1165pn48v6t4vgvvivg prices
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode([Quotes].self, from: data!)
            withCompletion(decode)
            self.group.leave()
        }.resume()
    }
    
    func loadPopular(completion withCompletion: @escaping (PopularIndices?) -> Void) {
        group.enter()
        let mineURL = URL(string: "https://finnhub.io/api/v1/index/constituents?symbol=^GSPC&token=c1165pn48v6t4vgvvivg")
//        https://finnhub.io/api/v1/index/constituents?symbol=^GSPC&token=c1165pn48v6t4vgvvivg
        let url = URL(string: "\(baseUrl)index/constituents?symbol=^GSPC&token=\(token)")
        //        let url = URL(string: "\(baseUrl)stock/symbol?exchange=US&token=\(token)")
        //https://finnhub.io/api/v1/quote?symbol=AAPL&token=c1165pn48v6t4vgvvivg prices
        guard let popularURL = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: mineURL!) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(PopularIndices.self, from: data!)
            DispatchQueue.global(qos: .utility).async {
                withCompletion(decode)
                self.group.leave()
            }
            
        }.resume()
    }
    
    func loadCompanyProfile(companyName company: String, completion withCompletion: @escaping (Profile?) -> Void) {
        group.enter()
        let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(company)&token=c1165pn48v6t4vgvvivg")
        guard let mineURL = url else  { withCompletion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: mineURL) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(Profile.self, from: data!)
            DispatchQueue.global(qos: .utility).async {
                var f = response as? HTTPURLResponse
                print("status code: \(f?.statusCode)")
                withCompletion(decode)
                self.group.leave()
            }
        }.resume()
    }
    
  
    
    func getDetails(company: String, completion withCompletion: @escaping (Profile?, StockPrice?) -> Void) {
        let myGroup = DispatchGroup()
        var p: Profile?
        var q: StockPrice?
        
        if let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(company)&token=c1165pn48v6t4vgvvivg") {
            myGroup.enter()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(Profile.self, from: data!)
//            DispatchQueue.global(qos: .utility).async {
                var f = response as? HTTPURLResponse
                print("status code: \(f?.statusCode)")
//                withCompletion(decode)
                p = decode
                myGroup.leave()
//            }
        }.resume()
        }
        
        if  let mineURL = URL(string: "\(baseUrl)quote?symbol=\(company)&token=\(token)") {
            myGroup.enter()
        let task = URLSession.shared.dataTask(with: mineURL) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(StockPrice.self, from: data!)
//            withCompletion(decode)
                q = decode
//            self.delegate?.didUpdatePrice(price: decode?.c ?? 0)
            myGroup.leave()
        }.resume()
        }
        myGroup.notify(queue: .main) {
            withCompletion(p, q)
        }
        
    }
    
    func loadCompanyPopularIndices(completion withCompletion: @escaping (PopularIndices?) -> Void) {
        group.enter()
        //MARK: TODO MOVE FROM HERE
        var compoments = URLComponents()
        compoments.scheme = "https"
        compoments.host = "finnhub.io"
        compoments.path = "/api/v1/index/constituents"
        let queryItemSymbol = URLQueryItem(name: "symbol", value: "^GSPC")
        let queryItemToken = URLQueryItem(name: "token", value: "c1165pn48v6t4vgvvivg")
        compoments.queryItems = [queryItemSymbol, queryItemToken]
        let componentsURL = compoments.url
        guard let mineURL = componentsURL else  { withCompletion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: mineURL) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(PopularIndices.self, from: data!)
            DispatchQueue.global(qos: .utility).async {
                var f = response as? HTTPURLResponse
                print("status code: \(f?.statusCode)")
                withCompletion(decode)
                self.group.leave()
            }
        }.resume()
    }
    
    func loadStockPrice(companyName company: String, completion withCompletion: @escaping (StockPrice?) -> Void) {
        group.enter()
        let mineURL = URL(string: "\(baseUrl)quote?symbol=\(company)&token=\(token)")
        guard let url = mineURL  else {
            withCompletion(nil)
            return
            
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(StockPrice.self, from: data!)
            withCompletion(decode)
            self.delegate?.didUpdatePrice(price: decode?.c ?? 0)
            self.group.leave()
        }.resume()
    }
    
    func loadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        group.enter()
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard let url = URL(string: urlString)  else  {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.global(qos: .background).async {
                guard let self = self,
                      error == nil,
                      let data = data,
                      let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
                self.group.leave()
            }
        }.resume()
    }

}


extension URL {
    func get<T:Codable>(completion: @escaping (T?) -> Void) {
        let debug = true
        if debug {
            print("get: \(self.absoluteString)")
        }

        let session = URLSession.shared
        session.dataTask(with: self) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(decoded)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

}
