//
//  TabView.swift
//  StockSharesApp
//
//  Created by Maximus on 01.03.2021.
//

import UIKit


protocol FavouriteListDelegate: class {
    func showFavouriteList()
    func showList()
}
//MARK: TODO создать отдельный класс для favoutire tabview и detail tabview
class TabView: UIView, UIGestureRecognizerDelegate {
    weak var delegate: FavouriteListDelegate?
    var isSelected: Bool = true
    var isFavouriteSelected = false
    var isTitleSelected = true
    var label = UILabel()
    var labelFavourite = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(labelFavourite)
        label.text = "Stocks"
        label.font = .boldSystemFont(ofSize: 30)
        setupLabels()
        initGestureRecognizer()
        
       
    }
    
    func initGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapTitle(sender:)))
        gesture.delegate = self
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
    
        let favouriteGesture = UITapGestureRecognizer(target: self, action: #selector(tapFavourite))
        favouriteGesture.delegate = self
        
        
        labelFavourite.isUserInteractionEnabled = true
        labelFavourite.addGestureRecognizer(favouriteGesture)
    }
    
    @objc func tapTitle(sender: UITapGestureRecognizer) {
        isSelected = true
        isSelected = isTabSelected(label: label, isLabelSelected: isSelected)
        print("Title isSelected: \(isSelected)")
        print("IsFavouriteSelected: \(isFavouriteSelected)")
        delegate?.showList()
    }
    
    func isTabSelected(label: UILabel, isLabelSelected: Bool) -> Bool {
        if isLabelSelected {
            label.font = .boldSystemFont(ofSize: 30)
            label.textColor = .black
            return true
        } else {
            label.font = UIFont(name: "Montserrat-Bold", size: 10)
            label.textColor = .gray
            return false
        }
    }
    
    //delegate or closure?
    @objc func tapFavourite() {
        isSelected = isTabSelected(label: label, isLabelSelected: isSelected)
        delegate?.showFavouriteList()
    }
 
    //labels in stackview, use it in loop, find by index?
    private func setupLabels() {
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false, identifier: "label?")
        //MARK: TODO add internalization?
        labelFavourite.text = "Favourite"
        labelFavourite.textColor = .lightGray
        labelFavourite.font = UIFont(name: "Montserrat-Bold", size: 18)
        labelFavourite.anchor(top: topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false, identifier: "labelFavourite")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   
}
