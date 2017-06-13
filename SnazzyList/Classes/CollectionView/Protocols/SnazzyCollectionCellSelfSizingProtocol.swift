//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/**
 A Protocol that must be implemented in all your `UICollectionViewCell` that would response for their own size.
 */
public protocol SnazzyCollectionCellSelfSizingProtocol {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath, with item: Any) -> CGSize
}
