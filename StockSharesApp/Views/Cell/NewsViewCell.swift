//
//  NewsViewCell.swift
//  StockSharesApp
//
//  Created by Maximus on 14.05.2021.
//

import UIKit

class NewsViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var pubDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: News? {
        didSet {
            title.text = model?.title
            newsDescription.text = model?.newsDescription
            link.text = model?.link
            pubDate.text = model?.pubDate
        }
    }

}
