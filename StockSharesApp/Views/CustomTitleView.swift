//
//  CustomTitleView.swift
//  StockSharesApp
//
//  Created by Maximus on 29.04.2021.
//

import UIKit

class CustomTitleView: UIView {
    var titleLabel: UILabel?
  
    init(title: String, subtitle: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        titleLabel?.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
