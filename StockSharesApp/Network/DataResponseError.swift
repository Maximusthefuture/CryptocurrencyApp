//
//  DataResponseError.swift
//  StockSharesApp
//
//  Created by Maximus on 24.03.2021.
//

import Foundation

enum DataResponseError: Error {
    case network
    case decoding
    
    
    var reason: String {
        switch  self {
        case .network:
            return "Network Error"
        case .decoding:
            return "Decoding Error"
        }
    }
}
