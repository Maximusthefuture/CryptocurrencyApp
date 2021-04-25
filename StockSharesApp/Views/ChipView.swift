//
//  ChipView.swift
//  StockSharesApp
//
//  Created by Maximus on 08.04.2021.
//

import UIKit


class ChipView: UIView {
    
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.backgroundColor =
            UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1).cgColor
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 14.5
        self.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width - 8, height: 16)
        //        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //        label.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        //        label.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 16).isActive = true
    }
}
