//
//  Quotes.swift
//  StockSharesApp
//
//  Created by Maximus on 05.03.2021.
//

import Foundation

/*
 Плюс, в этом случае можно не заморачиваться с кастомной реализацией Codable,
 а создать объекты-обёртки, где необходимо, чтобы напрямую переводить JSON в объекты,
 поскольку это всё инкапсулировано в отдельном слое.
 */

struct Quotes: Codable {
    let quotes: [String]
    let count: Int
}

struct StockPrice: Codable {
    let c, h, l, o: Double
    let pc: Double
    let t: Int
}

struct Profile: Codable {
//    let country, currency, exchange, finnhubIndustry: String
//    let ipo: String
    let logo: String
//    let marketCapitalization: Int
    let name: String
//    let phone: String?
//    let shareOutstanding: Double
//    let ticker: String
//    let weburl: String
    
    enum CodingKeys: String, CodingKey {
        case logo
        case name
    }

}
struct PopularIndices: Codable {
    let constituents: [String]
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case constituents
        case symbol
    }
}



