//
//  NewsModel.swift
//  StockSharesApp
//
//  Created by Maximus on 14.05.2021.
//

import Foundation


struct NewsDataModel: Codable {
    let item: [News]
    let language, lastBuildDate: String
}

struct News: Codable, Hashable {
    let newsDescription: String
    let link: String
    let pubDate, title: String
    
    enum CodingKeys: String, CodingKey {
        case newsDescription = "description"
        case link, pubDate, title
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(newsDescription)
        hasher.combine(pubDate)
        hasher.combine(link)
    }
}
