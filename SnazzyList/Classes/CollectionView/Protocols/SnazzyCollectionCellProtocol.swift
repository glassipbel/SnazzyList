//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

@objc public protocol SnazzyCollectionCellProtocol {
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: Any)
    @objc optional func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func collectionView(collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath, with item: Any)
    @objc optional func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath, with item: Any)
}
