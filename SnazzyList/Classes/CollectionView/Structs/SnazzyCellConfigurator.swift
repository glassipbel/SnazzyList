//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/**
 This struct represents your cells for the `UICollectionView`, you must create on instance of this struct for each cell that you want to show in your `UICollectionView`.
 */
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

    /**
     Creates a new instance of the `SnazzyCollectionCellConfigurator`.
     - parameter classType: The class that represents your cell. For example if your cell's name is CustomCollectionViewCell, then you should enter: `CustomCollectionViewCell.self`
     - parameter typeCell: The type of your cell. [Cell, Header or Footer]
     - parameter item: The configFile for your cell, here you should pass all your items that you are going to need in order to configure your cell at cellForItemAtIndexPath.
     - parameter section: The section for this cell.
     - parameter sizingType: The way of determinate the size of this cell. For examples please take a look at the example guides.
     - parameter diffableIdentifier: You can provide a unique value, if you do, then you would only one cell with this identifier, even if you try to add more than one it will be ignored.
     - parameter originType: You must provide if the cell was designed by Code or by Xib File.
     - returns: An Instance of `SnazzyCollectionCellConfigurator`
     */
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
