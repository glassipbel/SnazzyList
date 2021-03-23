//
//  AccessibilityInfo.swift
//  Noteworth2
//
//  Created by Dmytro Skorokhod on 11.02.2021.
//  Copyright © 2021 Noteworth. All rights reserved.
//

import Foundation

public struct AccessibilityInfo {
    public let index: Int?
    public var indexPath: IndexPath?
    public let purpose: String?
    
    public init(index: Int? = nil,
                indexPath: IndexPath? = nil,
                purpose: String? = nil) {
        self.index = index
        self.indexPath = indexPath
        self.purpose = purpose
    }
}
