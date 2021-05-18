//
//  DetailTabView.swift
//  StockSharesApp
//
//  Created by Maximus on 05.05.2021.
//

import Foundation
import UIKit


enum TabOptions: Int {
    case one = 0
    case two
    case three
    case four
    case five
    case six
}


protocol TabDelegate {
    func tabClicked(option: TabOptions)
}

class DetailTabView: UIView, UIGestureRecognizerDelegate {
    
    var stackView: UIStackView!
    var gesture: UIGestureRecognizer!
    var tabDelegate: TabDelegate?
    var arrayOfLabels: [UILabel] = []
    var tabOption: TabOptions = .one
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        self.addSubview(stackView)
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabClicked(sender: UITapGestureRecognizer) {
        let view = sender.view as? UILabel
        setUpTitles(label: view!)
        //Generic enum by index?
        tabDelegate?.tabClicked(option: tabOption)
    }
    
    private func configureStackView() {
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
  
    func setUpTitles(label: UILabel) {
        arrayOfLabels.forEach { myLabel in
            myLabel.textColor = .gray
            myLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        }
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        tabOption = getSelectedTabOption(labels: arrayOfLabels)
        print("tabOption: \(tabOption)")
    }
    
    func addToSubView(titles: [String]) {
        titles.forEach { title in
            let label = UILabel()
            gesture = UITapGestureRecognizer(target: self, action: #selector(tabClicked(sender:)))
            label.text = title
            label.textColor = .gray
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(gesture)
            label.font = .systemFont(ofSize: 14, weight: .semibold)
            arrayOfLabels.append(label)
            stackView.addArrangedSubview(label)
            setNeedsLayout()
        }
    }
}

extension DetailTabView {
    func getSelectedTabOption(labels: [UILabel]) -> TabOptions {
        let color = UIColor.black
        for (index, label) in labels.enumerated() {
            if label.textColor == color {
            print("index: \(index)")
                return TabOptions(rawValue: index) ?? .one
            }
        }
        return .one
    }
}
