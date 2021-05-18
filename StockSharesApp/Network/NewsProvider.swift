//
//  NewsProvider.swift
//  StockSharesApp
//
//  Created by Maximus on 18.05.2021.
//

import Foundation

protocol NewsProvider {
    func getNews<T: Codable, E: Error>(symbol: String, competion withCompletion: @escaping (Result<T, E>) -> Void)
}
