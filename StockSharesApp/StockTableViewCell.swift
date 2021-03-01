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
    
    var stock: Model? {
        didSet {
            companyImage.image = stock!.image
            companyShortNameLabel.text = stock?.title
            companyFullNameLabel.text = stock?.subtitle
            changePrice.text = stock?.changePrice
            companyPrice.text = "\(stock!.price) ₽"
        }
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
        image.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        
        return image
    }()
    
    private let companyPrice: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
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
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
     private let roundedRect: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .blue
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
        setConstaints()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundedRect.clipsToBounds = true
        
        //yourTableViewCell.contentView.layer.cornerRadius = 5
        //       contentView.layer.borderWidth = 0.5
        //        contentView.layer.borderColor = UIColor.lightGray.cgColor
        //        contentView.layer.masksToBounds = true
        //        layer.shadowColor = UIColor.gray.cgColor
        //        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        //        layer.shadowRadius = 2.0
        //        layer.shadowOpacity = 1.0
        //        layer.masksToBounds = false
        //        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
        
        roundedRect.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: contentView.frame.width, height: contentView.frame.height, enableInsets: false)
        roundedRect.layer.masksToBounds = true

        }
    
    
    
    func setConstaints() {
        
        addSubview(roundedRect)
        addSubview(companyShortNameLabel)
        addSubview(companyFullNameLabel)
        addSubview(companyImage)
        addSubview(companyPrice)
        addSubview(changePrice)
        

        
        companyImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 16, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        companyShortNameLabel.anchor(top: topAnchor, left: companyImage.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 9, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        companyFullNameLabel.anchor(top: companyShortNameLabel.bottomAnchor, left: companyImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: frame.size.width / 2 , height: 0, enableInsets: false)
        
        companyPrice.anchor(top: topAnchor, left: companyShortNameLabel.rightAnchor, bottom: changePrice.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        changePrice.anchor(top: companyShortNameLabel.bottomAnchor, left: companyShortNameLabel.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
