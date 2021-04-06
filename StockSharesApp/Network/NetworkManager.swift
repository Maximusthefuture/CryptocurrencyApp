//
//  NetworkManager.swift
//
//  Created by Maximus on 09.03.2021.
//

import Foundation
import UIKit

class NetworkManager {
    
    var session = URLSession.shared
    private let token = "c1165pn48v6t4vgvvivg"
    let group = DispatchGroup()
    var baseUrl = "https://finnhub.io/api/v1/"
    var cache = NSCache<NSString, UIImage>()
    //MARK: TODO delete singlton!
    static let shared = NetworkManager()
    let finhubDataProvider = FinhubDataProvider()
    //MARK: TODO SET INIT
//    init(finhubDataProvider: FinhubDataProvider) {
//        self.finhubDataProvider = finhubDataProvider
//    }
 
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

