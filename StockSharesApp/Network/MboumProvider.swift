//
//  MboumProvider.swift
//  StockSharesApp
//
//  Created by Maximus on 18.05.2021.
//

import Foundation

class MboumProvider: NewsProvider {
   
    func getNews<T, E>(symbol: String = "AAPL", competion withCompletion: @escaping (Result<T, E>) -> Void) where T : Codable, E : Error {
        guard let url = URL(string: "https://mboum.com/api/v1/ne/news/?symbol=\(symbol)&apikey=demo") else {
            withCompletion(Result.failure(DataResponseError.network as! E))
            return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            guard let decode = try? JSONDecoder().decode(T.self, from: data!) else {
                withCompletion(Result.failure(DataResponseError.decoding as! E))
                return
            }
            withCompletion(Result.success(decode))
            
        }
        task.resume()
    }
}
