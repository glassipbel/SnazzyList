//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public enum CollectionCellType {
    case cell
    case header
    case footer
    
    static func getCollectionCellTypeBySupplementaryKind(kind: String) -> CollectionCellType? {
        switch kind {
        case UICollectionView.elementKindSectionHeader: return .header
        case UICollectionView.elementKindSectionFooter: return .footer
            default: return nil
        }
    }
}
