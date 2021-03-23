//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

protocol GenericCollectionReusableProtocol {
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath, with item: Any)
}
