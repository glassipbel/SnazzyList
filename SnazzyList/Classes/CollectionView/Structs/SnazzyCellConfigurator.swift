//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

public struct SnazzyCollectionCellConfigurator: Hashable, Equatable {
    public var typeCell: SnazzyCollectionCellType
    public var item: Any
    public var section: Int
    public var sizingType: SnazzyCollectionSizingType
    public var classType: AnyClass
    public var diffableIdentifier: String?
    public var cellOriginType: SnazzyCellOriginType
    
    public var className: String { return String(describing: classType) }
    public var hashValue: Int { return className.hash }
    
    public static func ==(lhs: SnazzyCollectionCellConfigurator, rhs: SnazzyCollectionCellConfigurator) -> Bool {
        return lhs.classType == rhs.classType
    }

    public init(classType: AnyClass, typeCell: SnazzyCollectionCellType = .cell, item: Any = "", section: Int = 0, sizingType: SnazzyCollectionSizingType, diffableIdentifier: String? = nil, originType: SnazzyCellOriginType) {
        self.classType = classType
        self.item = item
        self.section = section
        self.typeCell = typeCell
        self.sizingType = sizingType
        self.diffableIdentifier = diffableIdentifier
        self.cellOriginType = originType
    }
}
