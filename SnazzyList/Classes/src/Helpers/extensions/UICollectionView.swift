//
//  UICollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UICollectionView {
    static func getDefault(adjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .automatic, direction: UICollectionView.ScrollDirection = .vertical, itemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0, pinHeader: Bool = false, alwaysBounceVertical: Bool = true, contentInset: UIEdgeInsets = .zero, isPagingEnabled: Bool = false) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = direction
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionHeadersPinToVisibleBounds = pinHeader
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = alwaysBounceVertical
        collectionView.contentInset = contentInset
        collectionView.isPagingEnabled = isPagingEnabled
        collectionView.contentInsetAdjustmentBehavior = adjustmentBehavior
        collectionView.isAccessibilityElement = false
        return collectionView
    }
}
