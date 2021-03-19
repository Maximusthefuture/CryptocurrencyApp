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
    
    func loadCompanyProfile(companyName company: String, completion withCompletion: @escaping (Profile?) -> Void) {
        group.enter()
        let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(company)&token=c1165pn48v6t4vgvvivg")
        print("URL: \(url)")
        print(company)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(Profile.self, from: data!)
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
        let url = URL(string: "\(baseUrl)quote?symbol=\(company)&token=\(token)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(StockPrice.self, from: data!)
            withCompletion(decode)
            self.delegate?.didUpdatePrice(price: decode?.c ?? 0)
            self.group.leave()
        }.resume()
    }
    
    func loadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
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
            }
        }.resume()
    }
}
