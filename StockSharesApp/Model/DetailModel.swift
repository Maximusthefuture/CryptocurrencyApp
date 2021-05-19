//
//  DetailModel.swift
//  StockSharesApp
//
//  Created by Maximus on 05.05.2021.
//

import Foundation
import UIKit



enum DateType: Int {
    case day
    case week
    case month
    case halfYear
    case year
    case all
}

class DetailModel {
  
    func getSelectedDateType(buttons: [UIButton]) -> DateType {
        let color = UIColor.red
        for (index, button) in buttons.enumerated() {
            print("color:\(button.backgroundColor?.accessibilityName)")
            if button.backgroundColor == color {
            print("index: \(index)")
                return DateType(rawValue: index) ?? .all
            }
        }
        return .all
    }  
}
