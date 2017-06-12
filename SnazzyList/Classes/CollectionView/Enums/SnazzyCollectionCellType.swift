//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

public enum SnazzyCollectionCellType {
    case cell
    case header
    case footer
    
    static public func getCollectionCellTypeBySupplementaryKind(kind: String) -> SnazzyCollectionCellType? {
        switch kind {
            case UICollectionElementKindSectionHeader: return .header
            case UICollectionElementKindSectionFooter: return .footer
            default: return nil
        }
    }
}
