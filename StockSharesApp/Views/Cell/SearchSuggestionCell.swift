//
//  SearchSuggestionCell.swift
//  StockSharesApp
//
//  Created by Maximus on 02.04.2021.
//

import UIKit

protocol SetTextDeledate {
    func setText(string: String) -> String
}

class SearchSuggestionCell: UICollectionViewCell {
    
    var label: UILabel = UILabel()
    var chipView = ChipView()

    override init(frame: CGRect) {
        super.init(frame:  frame)
    }
    
    func configView() {
        chipView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width ,height: 40)
        chipView.label = label
        contentView.addSubview(chipView)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configView()
    }
    
}

extension String {
    func widthOfString(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
