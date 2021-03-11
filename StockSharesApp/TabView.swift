//
//  TabView.swift
//  StockSharesApp
//
//  Created by Maximus on 01.03.2021.
//

import UIKit


class TabView: UIView, UIGestureRecognizerDelegate {
    
    var isSelected: Bool = false
    var label = UILabel()
    var labelFavourite = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(labelFavourite)
        label.text = "Stocks"
        label.font = .boldSystemFont(ofSize: 30)
//        label.font = UIFont(name: "Montserrat-Bold", size: 28)
//        var paragraphStyle = NSParagraphStyle()
        
//        label.attributedText = NSAttributedString(string: "Stocks", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
       
        setupLabels()
        initGestureRecognizer()
        
       
    }
    
    func initGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapTitle(sender:)))
        gesture.delegate = self
        print("is gestureEnabled \(gesture.isEnabled)")
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        
        let favouriteGesture = UITapGestureRecognizer(target: self, action: #selector(tapFavourite))
        favouriteGesture.delegate = self
        labelFavourite.isUserInteractionEnabled = true
        labelFavourite.addGestureRecognizer(favouriteGesture)
//
    }

    @objc func tapTitle(sender: UITapGestureRecognizer) {
        print(label.text)
    }
    
    @objc func tapFavourite() {
        print(labelFavourite.text)
        isSelected = true
        if isSelected {
            UIView.animate(withDuration: 2.1, animations: { [self] in
                self.labelFavourite.font = .boldSystemFont(ofSize: 40)
                self.labelFavourite.textColor = .black
                self.label.font = UIFont(name: "Montserrat-Bold", size: 18)
                self.label.textColor = UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1)
            }, completion: nil)
            
        }
    }
    
    private func setupLabels() {
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        
        //MARK: TODO add internalization?
        labelFavourite.text = "Favourite"
        labelFavourite.textColor = .lightGray
        labelFavourite.font = UIFont(name: "Montserrat-Bold", size: 18)
        
        
        labelFavourite.anchor(top: topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
