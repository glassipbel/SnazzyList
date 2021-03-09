//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/**
 A Protocol that must be implemented in all your `UICollectionViewCell`.
 */
@objc public protocol SnazzyCollectionCellProtocol {
    /**
     This method will be called whenever the `UICollectionView` will call the `cellForItemAt`.
     You will receive in the parameter `item` all the values that you entered when you created the configFile.
     
     - parameter collectionView: The `UICollectionView` that is handling this cell.
     - parameter cellForItemAt: The indexPath for this cell.
     - parameter with: All the values that you entered when you created the configFile.
     */
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: Any)
    @objc optional func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func collectionView(collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath, with item: Any)
    @objc optional func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath, with item: Any)
}
