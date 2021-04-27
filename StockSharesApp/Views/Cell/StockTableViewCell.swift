//
//  StockTableViewCell.swift
//  StockSharesApp
//
//  Created by Maximus on 25.02.2021.
//

import UIKit

protocol FavouriteDelegate {
    func isFavourite(cell: StockTableViewCell) -> Bool
    func setFavourite(cell: StockTableViewCell)
}

class StockTableViewCell: UITableViewCell {
    
    var delegate: FavouriteDelegate?
    let tickerImage = CProfileImageView(frame: .zero)
    
    func configure(with model: Model?) {
        if let model = model {
            companyShortNameLabel.text = model.ticker
            companyFullNameLabel.text = model.name
            if model.changePrice < 0 {
                changePrice.textColor = .red
            } else {
                changePrice.textColor = .green
            }
            changePrice.text = model.formattedChangePrice()
            companyPrice.text = model.formattedPrice()
            favouriteButton.isSelected = model.isFavourite
            favouriteButton.alpha = 1 
        }
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
        //label.font = UIFont(name: "Montserrat-SemiBold", size: 11)
        label.font = label.font.withSize(11)
        return label
    }()
    
    private let companyPrice: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        return label
    }()
    
    var changePrice: UILabel = {
        var label = UILabel()
        return label
    }()
    
    let favouriteButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "FavouriteFilled"), for: .selected)
        button.setImage(UIImage(named: "FavouriteButton"), for: .normal)
        return button
    }()
    
    var  roundedRect: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstaints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedRect.translatesAutoresizingMaskIntoConstraints = false
        roundedRect.clipsToBounds = true
        let roundedBottom = roundedRect.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        roundedBottom.priority = UILayoutPriority(rawValue: 999)
        roundedBottom.isActive = true
        let roundedTop =  roundedRect.topAnchor.constraint(equalTo: topAnchor)
        roundedTop.priority = UILayoutPriority(rawValue: 999)
        roundedTop.isActive = true
        let roundedLeft =  roundedRect.leftAnchor.constraint(equalTo: leftAnchor)
        roundedLeft.priority = UILayoutPriority(rawValue: 999)
        roundedLeft.isActive = true
        let roundedRight =  roundedRect.rightAnchor.constraint(equalTo: rightAnchor)
        roundedRight.priority = UILayoutPriority(rawValue: 999)
        roundedRight.isActive = true
        roundedRect.layer.masksToBounds = true 
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyShortNameLabel.text = nil
        companyFullNameLabel.text = nil
        tickerImage.image = nil
        companyPrice.text = nil
        changePrice.text = nil
    }
    
    func set(profile: Model?) {
        tickerImage.downloadImage(fromURL: profile?.logo ?? "")
    }
 
    @objc func didTapButton(sender: UIButton) {
        delegate?.isFavourite(cell: self)
    }
    
    func setConstaints() {
        contentView.addSubview(roundedRect)
        contentView.addSubview(companyShortNameLabel)
        contentView.addSubview(companyFullNameLabel)
        contentView.addSubview(tickerImage)
        contentView.addSubview(changePrice)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(companyPrice)
        
        favouriteButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        tickerImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 16, paddingRight: 0, width: 90, height: 52, enableInsets: false, identifier: "tickerImage")
        companyShortNameLabel.anchor(top: roundedRect.topAnchor, left: tickerImage.rightAnchor, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 9, paddingBottom: 30, paddingRight: 0, width: 0, height: 0, enableInsets: false, identifier: "companyShortNameLabel")
        companyFullNameLabel.anchor(top: companyShortNameLabel.bottomAnchor, left: tickerImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0 , height: 0, enableInsets: false, identifier: "companyFullNameLabel")
        favouriteButton.anchor(top: companyShortNameLabel.topAnchor, left: companyShortNameLabel.rightAnchor, bottom: companyShortNameLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 6, width: 0, height: 0, enableInsets: false, identifier: "favouriteButton")
        companyPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        companyPrice.anchor(top: companyShortNameLabel.topAnchor, left: nil, bottom: companyShortNameLabel.bottomAnchor, right:  nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0, enableInsets: true, identifier: "companyPrice")
        changePrice.anchor(top: companyFullNameLabel.topAnchor, left: nil, bottom: companyFullNameLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false, identifier: "changePrice")
        changePrice.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
