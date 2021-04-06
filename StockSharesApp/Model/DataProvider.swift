//
//  DataProvider.swift
//  StockSharesApp
//
//  Created by Maximus on 31.03.2021.
//

import Foundation


protocol DataProvider {
    func loadPopular<T: Codable>(completion withCompletion: @escaping (T?) -> Void)
    func getDetails<T: Codable, U: Codable>(company: String, completion withCompletion: @escaping (T?, U?) -> Void)
}
