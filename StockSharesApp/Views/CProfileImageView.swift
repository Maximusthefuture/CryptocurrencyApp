//
//  CProfileImageView.swift
//  StockSharesApp
//
//  Created by Maximus on 12.03.2021.
//

import Foundation
import UIKit

class CProfileImageView: UIImageView {
    let cache = NetworkManager.shared.cache
    let imagePlaceholder = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        layer.cornerRadius = 20
        clipsToBounds = true
        image = imagePlaceholder
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url: String) {
        NetworkManager.shared.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
    }
    
}
