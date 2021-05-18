//
//  NewsModel.swift
//  StockSharesApp
//
//  Created by Maximus on 18.05.2021.
//

import Foundation

protocol NewsFetchDelegate: class {
    func fetchCompleted()
    func fetchFailed(reason: String)
}

class NewsModel {
    let newsProvider: NetworkManager?
    var newsList: [News] = []
    weak var delegate: NewsFetchDelegate?
    
    init(newsProvider: NetworkManager, delegate: NewsFetchDelegate) {
        self.newsProvider = newsProvider
        self.delegate = delegate
    }
    
    func fetchNews(symbol: String) {
        self.newsProvider?.fetchNews { result in
            switch result {
            case .success(let response):
                self.newsList.append(contentsOf: response.item)
                print("newsListCount: \(self.newsList.count)")
                self.delegate?.fetchCompleted()
            case .failure(let error):
                self.delegate?.fetchFailed(reason: error.reason)
            }
        }
    }

}
