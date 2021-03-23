//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import SnazzyAccessibility
import UIKit

public struct GenericCollectionCellConfigurator: Hashable {
    public var typeCell: CollectionCellType
    public var item: Any
    public var section: Int
    var sizingType: SizingType
    var classType: AnyClass
    var diffableIdentifier: String?
    var accessibilityInfo: AccessibilityInfo?
    
    var className: String { return String(describing: classType) }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(className)
    }
    
    // TODO: NuSs >> improve this
    public static func ==(lhs: GenericCollectionCellConfigurator, rhs: GenericCollectionCellConfigurator) -> Bool {
        return lhs.classType == rhs.classType
    }

    public init(classType: AnyClass , typeCell: CollectionCellType = .cell, item: Any = "", section: Int = 0, sizingType: SizingType, diffableIdentifier: String? = nil, accessibilityInfo: AccessibilityInfo? = nil) {
        self.classType = classType
        self.item = item
        self.section = section
        self.typeCell = typeCell
        self.sizingType = sizingType
        self.diffableIdentifier = diffableIdentifier
        self.accessibilityInfo = accessibilityInfo
    }
}
