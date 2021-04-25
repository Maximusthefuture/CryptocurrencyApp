//
//  PopularRequestHeaderView.swift
//  StockSharesApp
//
//  Created by Maximus on 09.04.2021.
//

import UIKit

class PopularRequestHeaderView: UICollectionReusableView {
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        var paragraphStyle = NSMutableParagraphStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
