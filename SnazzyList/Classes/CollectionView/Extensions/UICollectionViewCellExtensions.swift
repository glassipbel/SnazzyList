//
//  UICollectionViewCellExtensions.swift
//  Pods
//
//  Created by Kevin Belter on 6/8/17.
//
//

import UIKit

extension UICollectionViewCell {
    public func selfSizing(desiredWidth: CGFloat) -> CGSize {
        let size = contentView.systemLayoutSizeFitting(CGSize(width: desiredWidth, height: UILayoutFittingCompressedSize.height), withHorizontalFittingPriority: 1000.0, verticalFittingPriority: 250.0)
        return CGSize(width: desiredWidth, height: ceil(size.height))
    }
}
