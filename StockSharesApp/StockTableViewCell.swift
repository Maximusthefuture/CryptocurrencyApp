//
//  StockTableViewCell.swift
//  StockSharesApp
//
//  Created by Maximus on 25.02.2021.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private let companyShortNameLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        return label
    }()
    
    private let companyFullNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        return label
    }()
    
    
    private let companyImage: UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    private let companyPrice: UILabel = {
        var label = UILabel()
        return label
    }()
    
    private let changePrice: UILabel = {
        //need to change color
        var label = UILabel()
        label.textColor = .green
        return label
    }()
    
    private let favouriteButton: UIButton = {
        var button = UIButton()
        //как менять статус кнопки
        button.backgroundColor = .yellow
        //        if isFavorite {
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        //        } else {
        button.setImage(UIImage(systemName: "star"), for: .normal)
        //        }
        
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(companyShortNameLabel)
        addSubview(companyFullNameLabel)
        addSubview(companyImage)
        addSubview(companyPrice)
        addSubview(changePrice)
        
    }
    
    
    func setConstaints() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
