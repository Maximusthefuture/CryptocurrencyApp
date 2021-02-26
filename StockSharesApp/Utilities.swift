//
//  Utilities.swift
//  StockSharesApp
//
//  Created by Maximus on 25.02.2021.
//

import Foundation
import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,
                left: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat,
                paddingLeft: CGFloat,
                paddingBottom: CGFloat,
                paddingRight: CGFloat,
                width: CGFloat,
                height: CGFloat,
                enableInsets: Bool) {
        
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
    }
}
