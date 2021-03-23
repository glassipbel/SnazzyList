//
//  Accessible.swift
//  Noteworth2
//
//  Created by Dmytro Skorokhod on 09.02.2021.
//  Copyright © 2021 Noteworth. All rights reserved.
//

import Foundation

public protocol Accessible: class {
}

public extension Accessible {
    func setupAccessibilityIdentifiersForViewProperties(withAccessibilityInfo accessibilityInfo: AccessibilityInfo? = nil) {
        #if DEBUG
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let view = child.value as? UIView,
               let identifier = child.label?.replacingOccurrences(of: ".storage", with: "") {
                var accessibilityId = "\(type(of: self)).\(identifier)"
                
                if let indexPath = accessibilityInfo?.indexPath {
                    accessibilityId += ".s\(indexPath.section)-r\(indexPath.row)"
                }
                
                if let index = accessibilityInfo?.index {
                    accessibilityId += ".\(index)"
                }
                
                if let purpose = accessibilityInfo?.purpose {
                    accessibilityId += ".\(purpose)"
                }
                
                view.accessibilityIdentifier = accessibilityId
            }
        }
        #endif
    }
}
