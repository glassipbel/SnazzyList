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
    public var item: GenericCellItemable
    public var section: Int
    public var sizingType: SizingType
    public var classType: AnyClass
    public var diffableIdentifier: String?
    public var accessibilityInfo: AccessibilityInfo?
    
    public var className: String { return String(describing: classType) }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(item.id)
    }
    
    public static func == (lhs: GenericCollectionCellConfigurator, rhs: GenericCollectionCellConfigurator) -> Bool {
        return lhs.item.id == rhs.item.id
    }

    public init(classType: AnyClass, typeCell: CollectionCellType = .cell, item: GenericCellItemable = GenericCellItem(), section: Int = 0, sizingType: SizingType, diffableIdentifier: String? = nil, accessibilityInfo: AccessibilityInfo? = nil) {
        self.classType = classType
        self.item = item
        self.section = section
        self.typeCell = typeCell
        self.sizingType = sizingType
        self.diffableIdentifier = diffableIdentifier
        self.accessibilityInfo = accessibilityInfo
    }
}
