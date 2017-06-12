//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

public struct SnazzyTableCellConfigurator: Hashable, Equatable {
    public var typeCell: SnazzyTableCellType
    public var item: Any
    public var section: Int
    public var sizingType: SnazzyTableSizingType
    public var classType: AnyClass
    public var cellOriginType: SnazzyCellOriginType
    
    public var className: String { return String(describing: classType) }
    public var hashValue: Int { return className.hash }
    
    public static func ==(lhs: SnazzyTableCellConfigurator, rhs: SnazzyTableCellConfigurator) -> Bool {
        return lhs.classType == rhs.classType
    }
    
    public init(classType: AnyClass, typeCell: SnazzyTableCellType = .cell, item: Any = "", section: Int = 0, sizingType: SnazzyTableSizingType = .automatic, originType: SnazzyCellOriginType) {
        self.classType = classType
        self.item = item
        self.section = section
        self.typeCell = typeCell
        self.sizingType = sizingType
        self.cellOriginType = originType
    }
}
