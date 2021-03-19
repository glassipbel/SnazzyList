//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

@objc public protocol GenericCollectionCellProtocol {
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: Any)
    @objc optional func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func collectionView(collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath, with item: Any)
    @objc optional func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath, with item: Any)
}
