//
//  DetailTabView.swift
//  StockSharesApp
//
//  Created by Maximus on 05.05.2021.
//

import Foundation
import UIKit

class DetailTabView: UIView {
    
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        self.addSubview(stackView)
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func addToSubView(titles: [String]) {
        titles.forEach { title in
            let label = UILabel()
            label.text = title
            label.textColor = .black
            stackView.addArrangedSubview(label)
            setNeedsLayout()
            
        }
    }
}
