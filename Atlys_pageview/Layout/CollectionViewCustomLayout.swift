//
//  CollectionViewCustomLayout.swift
//  Atlys_pageview
//
//  Created by Coditas on 17/08/24.
//

import Foundation
import UIKit

class CollectionViewCustomFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let itemSize = CGSize(width: collectionView.bounds.width * Constants.imageCellSizeMultiplier,
                              height: collectionView.bounds.width * Constants.imageCellSizeMultiplier)
        self.itemSize = itemSize
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        let insetX = (collectionView.bounds.width - itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(top: 0, left: insetX, bottom: 0, right: insetX)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = collectionView else { return attributes }
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.size.width / 2
        for attribute in attributes {
            let distance = abs(attribute.center.x - centerX)
            let scale = max(Constants.zoomScale - (distance / collectionView.bounds.size.width), Constants.normalScale)
            if scale > Constants.normalScale {
                attribute.zIndex = 1
            } else {
                attribute.zIndex = 0
            }
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return attributes
    }
}
