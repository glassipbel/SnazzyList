//
//  UICollectionViewCell.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func selfSizing(desiredWidth: CGFloat) -> CGSize {
        let size = contentView.systemLayoutSizeFitting(CGSize(width: desiredWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: UILayoutPriority(rawValue: 1000.0), verticalFittingPriority: UILayoutPriority(rawValue: 250.0))
        return CGSize(width: desiredWidth, height: ceil(size.height))
    }
    
    func selfSizing(desiredHeight: CGFloat) -> CGSize {
        let size = contentView.systemLayoutSizeFitting(CGSize(width: UIView.layoutFittingCompressedSize.width, height: desiredHeight), withHorizontalFittingPriority: UILayoutPriority(rawValue: 250.0), verticalFittingPriority: UILayoutPriority(rawValue: 1000.0))
        return CGSize(width: ceil(size.width), height: desiredHeight)
    }
    
    func setupBackground(backgroundColor: UIColor = .white) {
        self.contentView.backgroundColor = backgroundColor
        self.backgroundColor = backgroundColor
    }
}
