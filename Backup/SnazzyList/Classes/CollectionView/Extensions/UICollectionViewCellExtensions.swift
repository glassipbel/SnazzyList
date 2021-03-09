//
//  Created by Kevin Belter on 6/8/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    /**
     A helper method for getting the minimum size for the `UICollectionViewCell`.
     */
    public func selfSizing(desiredWidth: CGFloat) -> CGSize {
        let size = contentView.systemLayoutSizeFitting(CGSize(width: desiredWidth, height: UILayoutFittingCompressedSize.height), withHorizontalFittingPriority: 1000.0, verticalFittingPriority: 250.0)
        return CGSize(width: desiredWidth, height: ceil(size.height))
    }
}
