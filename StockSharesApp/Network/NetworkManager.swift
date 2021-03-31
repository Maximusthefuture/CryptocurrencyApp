//
//  NetworkManager.swift
//
//  Created by Maximus on 09.03.2021.
//

import Foundation
import UIKit


 struct FinhubDataProvider: FinhubProvider {
    
    
    private let token = "c1165pn48v6t4vgvvivg"
    let group = DispatchGroup()
    var baseUrl = "https://finnhub.io/api/v1/"
    var cache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()
   

    func loadPopular<T: Codable>(completion withCompletion: @escaping (T?) -> Void) {
        group.enter()
        //MARK: TODO MOVE FROM HERE
        var components = URLComponents()
        components.scheme = "https"
        components.host = "finnhub.io"
        components.path = "/api/v1/index/constituents"
        let queryItemSymbol = URLQueryItem(name: "symbol", value: "^GSPC")
        let queryItemToken = URLQueryItem(name: "token", value: token)
        components.queryItems = [queryItemSymbol, queryItemToken]
        let componentsURL = components.url
        guard let mineURL = componentsURL else  { withCompletion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: mineURL) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(T.self, from: data!)
            DispatchQueue.global(qos: .utility).async {
                var f = response as? HTTPURLResponse
                print("status code: \(f?.statusCode)")
                withCompletion(decode as! T)
                self.group.leave()
            }
        }.resume()
    }
    
    func getDetails<T: Codable, U: Codable>(company: String, completion withCompletion: @escaping (T?, U?) -> Void) {
        let myGroup = DispatchGroup()
        var p: T?
        var q: U?
        
        if let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(company)&token=c1165pn48v6t4vgvvivg") {
            myGroup.enter()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            let decode = try? JSONDecoder().decode(T.self, from: data!)
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
            let decode = try? JSONDecoder().decode(U.self, from: data!)
                q = decode
            myGroup.leave()
        }.resume()
        }
        myGroup.notify(queue: .main) {
            withCompletion(p, q)
        }
    }
    
    
}

class NetworkManager {
    
    var session = URLSession.shared
   
    private let token = "c1165pn48v6t4vgvvivg"
    let group = DispatchGroup()
    var baseUrl = "https://finnhub.io/api/v1/"
    var cache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()
    let finhubDataProvider = FinhubDataProvider()

    
    func getDetails(company: String, completion withCompletion: @escaping (Profile?, StockPrice?) -> Void) {
        finhubDataProvider.getDetails(company: company, completion: withCompletion)
        
    }
    
    func loadCompanyPopularIndices(completion withCompletion: @escaping (PopularIndices?) -> Void) {
        finhubDataProvider.loadPopular(completion: withCompletion)
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
