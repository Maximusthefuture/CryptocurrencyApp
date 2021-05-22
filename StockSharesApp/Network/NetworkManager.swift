//
//  NetworkManager.swift
//
//  Created by Maximus on 09.03.2021.
//

import Foundation
import UIKit

class NetworkManager {
  
    var session = URLSession.shared
//    private let token = "c1165pn48v6t4vgvvivg"
    private let token = "sandbox_c1165pn48v6t4vgvvj00"
    
    let group = DispatchGroup()
    var baseUrl = "https://finnhub.io/api/v1/"
    var cache = NSCache<NSString, UIImage>()
    //MARK: TODO delete singlton!
    static let shared = NetworkManager(provider: FinhubDataProvider())
    let finhubDataProvider = FinhubDataProvider()
    let provider: DataProvider?
    var newsProvider: NewsProvider?
//    let mboumProvider = MboumProvider()
    
    init(provider: DataProvider?) {
        self.provider = provider
    }
    
    convenience init(newsProvider: NewsProvider) {
        self.init(provider: nil) //??????????
        self.newsProvider = newsProvider
    }
    
    //мне нужен нетворк провайдер который будет принимать дата провайдер.
    //чтобы я мог подставить сюда любой API
    //DI principle
    //MARK: TODO SET INIT
//    init(finhubDataProvider: DataProvider) {
//        self.finhubDataProvider = finhubDataProvider
//    }
    
   
    func fetchNews(symbol: String = "AAPL", completion withCompletion: @escaping (Result<NewsDataModel, DataResponseError>) -> Void) {
        if let provider = newsProvider {
            provider.getNews(symbol: symbol, competion: withCompletion)
        } else {
            print("ERROR BLYAT")
        }
      
    }
 
    func getDetails(company: String, completion withCompletion: @escaping (Profile?, StockPrice?) -> Void) {
        if let provider = provider {
            provider.getDetails(company: company, completion: withCompletion)
        }
    }
    
    func loadCompanyPopularTest(completion withCompletion: @escaping (Result<PopularIndices, DataResponseError>) -> Void) {
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
                      let res = response as? HTTPURLResponse,
                      res.hasSuccessStatusCode,
                      let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
                self.group.leave()
            }
        }
        task.resume()
    }    
}

