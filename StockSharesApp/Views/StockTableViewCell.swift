//
//  StockTableViewCell.swift
//  StockSharesApp
//
//  Created by Maximus on 25.02.2021.
//

import UIKit

protocol FavouriteDelegate {
    func isFavourite(cell: StockTableViewCell) -> Bool
}

class StockTableViewCell: UITableViewCell {
    
    //need???
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var delegate: FavouriteDelegate?
    let tickerImage = CProfileImageView(frame: .zero)
    
    //??????
    var stock: Model? {
        didSet {
//            companyImage.image = stock!.image
            companyShortNameLabel.text = stock?.shortName
            companyFullNameLabel.text = stock?.longName
            changePrice.text = stock?.changePrice
            companyPrice.text = "\(stock!.price) ₽"
        }
    }
    
    var companyShortNameLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        return label
    }()
    
    var companyFullNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        //label.font = UIFont(name: "Montserrat-SemiBold", size: 11)
        label.font = label.font.withSize(11)
        return label
    }()
    
    var companyPrice: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        return label
    }()
    
     var changePrice: UILabel = {
        //need to change color
        var label = UILabel()
        label.textColor = .green
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
        roundedRect.clipsToBounds = true
        roundedRect.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: contentView.frame.width, height: contentView.frame.height, enableInsets: false)
        roundedRect.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyShortNameLabel.text = nil
        companyFullNameLabel.text = nil
        tickerImage.image = nil
        companyPrice.text = nil
        
    }
    
    func set(profile: Profile?) {
        tickerImage.downloadImage(fromURL: profile?.logo ?? "")
    }
    
    //MARK: TODO RENAME
    func funcfromdelegate() {
        print("FDSFSDF")
        delegate?.isFavourite(cell: self)
    }
    
    @objc func didTapButton(sender: UIButton) {
        print("button clicked \(sender)")
        var f = delegate?.isFavourite(cell: self)
        if f! {
            sender.isSelected = true
        } else {
            sender.isSelected = false
        }
        funcfromdelegate()
    }
    
    func setConstaints() {
        contentView.addSubview(roundedRect)
        contentView.addSubview(companyShortNameLabel)
        contentView.addSubview(companyFullNameLabel)
        contentView.addSubview(tickerImage)
        contentView.addSubview(changePrice)
        contentView.addSubview(favouriteButton)
        roundedRect.addSubview(companyPrice)
        
        favouriteButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        tickerImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 16, paddingRight: 0, width: 90, height: 52, enableInsets: false)
        companyShortNameLabel.anchor(top: topAnchor, left: tickerImage.rightAnchor, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 9, paddingBottom: 30, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        companyFullNameLabel.anchor(top: companyShortNameLabel.bottomAnchor, left: tickerImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0 , height: 0, enableInsets: false)
        favouriteButton.anchor(top: companyShortNameLabel.topAnchor, left: companyShortNameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 16, height: 16, enableInsets: false)
        companyPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        companyPrice.anchor(top: topAnchor, left: nil, bottom: changePrice.topAnchor, right:  nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0, enableInsets: true)
        changePrice.anchor(top: companyShortNameLabel.bottomAnchor, left: companyShortNameLabel.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
