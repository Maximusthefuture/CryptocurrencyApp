//
//  DataProvider.swift
//  StockSharesApp
//
//  Created by Maximus on 31.03.2021.
//

import Foundation


protocol DataProvider: AnyObject {
    func loadPopular<T: Codable, E: Error>(completion withCompletion: @escaping (Result<T, E>) -> Void)
    func getDetails<T: Codable, U: Codable>(company: String, completion withCompletion: @escaping (T?, U?) -> Void)
    func getSearchResults<T: Codable>(query: String, completion withCompletion: @escaping (T?) -> Void)
    
}
