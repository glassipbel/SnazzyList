//
//  TableView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import SnazzyAccessibility
import UIKit

public struct GenericTableCellConfigurator: Hashable {
    public var typeCell: TableCellType
    public var item: Any
    public var section: Int
    var sizingType: TableSizingType
    public var classType: AnyClass
    var accessibilityInfo: AccessibilityInfo?
    
    var className: String { return String(describing: classType) }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(className)
    }
    
    public static func ==(lhs: GenericTableCellConfigurator, rhs: GenericTableCellConfigurator) -> Bool {
        return lhs.classType == rhs.classType
    }
    
    public init(classType: AnyClass, typeCell: TableCellType = .cell, item: Any = "", section: Int = 0, sizingType: TableSizingType = .automatic, accessibilityInfo: AccessibilityInfo? = nil) {
        self.classType = classType
        self.item = item
        self.section = section
        self.typeCell = typeCell
        self.sizingType = sizingType
        self.accessibilityInfo = accessibilityInfo
    }
}
