//
//  Quotes.swift
//  StockSharesApp
//
//  Created by Maximus on 05.03.2021.
//

import Foundation

struct Quotes: Codable {
    let quotes: [String]
    let count: Int
}

struct Stock: Codable {
    let currency, description, displaySymbol, figi: String
       let mic, symbol, type: String

       enum CodingKeys: String, CodingKey {
           case currency
           case description = "description"
           case displaySymbol, figi, mic, symbol, type
       }
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
    let name, phone: String
//    let shareOutstanding: Double
//    let ticker: String
//    let weburl: String


}



