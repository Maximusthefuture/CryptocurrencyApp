//
//  FinhubProvider.swift
//  StockSharesApp
//
//  Created by Maximus on 31.03.2021.
//

import Foundation


protocol FinhubProvider: DataProvider {
}


class FinhubDataProvider: FinhubProvider {
   private let token = "c1165pn48v6t4vgvvivg"
   let group = DispatchGroup()
   var baseUrl = "https://finnhub.io/api/v1/"
    
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
               withCompletion(decode)
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
