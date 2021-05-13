//
//  HTTPURLResponse.swift
//  StockSharesApp
//
//  Created by Maximus on 25.03.2021.
//

import Foundation


extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
    
    var hasTooManyRequest: Bool {
        return 429 == statusCode
    }
}
