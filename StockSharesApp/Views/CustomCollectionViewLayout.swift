//
//  CustomCollectionViewLayout.swift
//  StockSharesApp
//
//  Created by Maximus on 06.04.2021.
//

import UIKit

protocol CustomCollectionViewLayoutDelegate : class {
    func collectionView(_ collectionView : UICollectionView, getSizeAtIndexPath indexPath : IndexPath)->CGSize
    
}

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    weak var delegate: CustomCollectionViewLayoutDelegate?
    
    private let minColumnWidth: CGFloat = 300.0
    private let cellHeight: CGFloat = 70.0
    
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.frame.width
    }
    
    private var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
}

extension CustomCollectionViewLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: 40)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea 
//
//        var xOrigin: CGFloat = 0
//        var yOrigin: CGFloat = 0
//
//        for item in 0..<collectionView.numberOfItems(inSection: 0) {
//            let indexPaht = IndexPath(item: item, section: 0)
//            let itemSize = delegate?.collectionView(collectionView, getSizeAtIndexPath: indexPaht) ?? CGSize(width: 10, height: 10)
////
//            if xOrigin + itemSize.width > contentWidth {
//                xOrigin = 0
//                yOrigin += itemSize.height
//            }
//
//            let frame = CGRect(x: xOrigin, y: yOrigin, width: contentWidth, height: contentHeight)
//
//            xOrigin += itemSize.width
//
//
//            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPaht)
//            attributes.frame = frame
//
//
//            contentHeight = max(contentHeight, yOrigin + itemSize.height)
//            contentWidth = max(contentWidth, xOrigin + itemSize.width)
//        }
    }
}
