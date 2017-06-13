//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/**
 This struct represents your cells for the `UITableView`, you must create on instance of this struct for each cell that you want to show in your `UITableView`.
 */
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
    
    /**
     Creates a new instance of the `SnazzyTableCellConfigurator`.
     - parameter classType: The class that represents your cell. For example if your cell's name is CustomTableViewCell, then you should enter: `CustomTableViewCell.self`
     - parameter typeCell: The type of your cell. [Cell, Header or Footer]
     - parameter item: The configFile for your cell, here you should pass all your items that you are going to need in order to configure your cell at `cellForRowAtIndexPath`.
     - parameter section: The section for this cell.
     - parameter sizingType: The way of determinate the size of this cell. For examples please take a look at the example guides.
     - parameter originType: You must provide if the cell was designed by Code or by Xib File.
     - returns: An Instance of `SnazzyTableCellConfigurator`
     */
    public init(classType: AnyClass, typeCell: SnazzyTableCellType = .cell, item: Any = "", section: Int = 0, sizingType: SnazzyTableSizingType = .automatic, originType: SnazzyCellOriginType) {
        self.classType = classType
        self.item = item
        self.section = section
        self.typeCell = typeCell
        self.sizingType = sizingType
        self.cellOriginType = originType
    }
}
