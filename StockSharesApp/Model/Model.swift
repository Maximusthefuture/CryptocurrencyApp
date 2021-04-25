//
//  Model.swift
//  StockSharesApp
//
//  Created by Maximus on 25.02.2021.
//

import Foundation
import UIKit

enum Currency: String {
    case US = "en_US"
    case RU = "ru_RU"
}

class Model: Hashable {
    
    let ticker: String
    let name: String
    let logo: String?
    let price: Double
    let changePrice: Double
    var isFavourite: Bool
    private let priceFormatter = NumberFormatter()
    private let changePriceFormatter = NumberFormatter()
    
    init(ticker: String, name: String, logo: String?, price: Double, changePrice: Double, isFavourite: Bool) {
        self.ticker = ticker
        self.name = name
        self.logo = logo
        self.price = price
        self.changePrice = changePrice
        self.isFavourite = isFavourite
        setup()
    }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.ticker  == rhs.ticker && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ticker)
        hasher.combine(name)
        hasher.combine(logo)
        hasher.combine(price)
        hasher.combine(changePrice)
        hasher.combine(isFavourite)
    }
    
    func setup() {
        priceFormatter.usesGroupingSeparator = true
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = Locale.init(identifier: "en_US")
        changePriceFormatter.numberStyle = .decimal
        changePriceFormatter.maximumFractionDigits = 2
        changePriceFormatter.numberStyle = .currency
        changePriceFormatter.locale = Locale.init(identifier: "en_US")
    }
    
    func formattedPrice() -> String? {
        priceFormatter.string(from: NSNumber(value: price))
    }
    
    func formattedChangePrice() -> String? {
        changePriceFormatter.string(from: NSNumber(value: changePrice))
    }
    
}
