//
//  Utilities.swift
//  StockSharesApp
//
//  Created by Maximus on 25.02.2021.
//

import Foundation
import UIKit


enum Images {
    static let placeholder = UIImage(named: "catplaceholder")
}

extension URL {
    func get<T:Codable>(completion: @escaping (T?) -> Void) {
        let debug = true
        if debug {
            print("get: \(self.absoluteString)")
        }
        
        let session = URLSession.shared
        session.dataTask(with: self) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(decoded)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,
                left: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat,
                paddingLeft: CGFloat,
                paddingBottom: CGFloat,
                paddingRight: CGFloat,
                width: CGFloat,
                height: CGFloat,
                enableInsets: Bool, identifier: String?) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        
        if #available(IOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            let topConstraint =  self.topAnchor.constraint(equalTo: top, constant: paddingTop)
            topConstraint.identifier = "top \(identifier!)"
            topConstraint.isActive = true
            
        }
        
        if let left = left {
            let leftConstraint = self.leftAnchor.constraint(equalTo: left, constant: paddingLeft)
            leftConstraint.identifier = "left \(identifier!)"
            leftConstraint.isActive = true
            
        }
        
        if let right = right {
            let rightConstraint =  self.leftAnchor.constraint(equalTo: right, constant: -paddingRight)
            rightConstraint.identifier = "right \(identifier!)"
            rightConstraint.isActive = true
            
        }
        
        if let bottom = bottom {
            let bottomConstraint = self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom)
            bottomConstraint.identifier = "bottom \(identifier!)"
            bottomConstraint.isActive = true
        }
        
        if height != 0 {
            let heightConstraint = heightAnchor.constraint(equalToConstant: height)
            heightConstraint.identifier = "height \(identifier!)"
            heightConstraint.isActive = true
        }
        
        if width != 0 {
            let widthConstraint =  widthAnchor.constraint(equalToConstant: width)
            widthConstraint.identifier = identifier
            widthConstraint.isActive = true
        }
    }
}

extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
