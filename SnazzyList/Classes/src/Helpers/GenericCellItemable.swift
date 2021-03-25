//
//  GenericTableCellItem.swift
//  SnazzyList
//
//  Created by Santiago Delgado on 24/03/21.
//

import Foundation

public protocol GenericCellItemable: Any {
    var id: String { get }
}

public struct GenericCellItem: GenericCellItemable {
    public var id: String = UUID().uuidString
    
    public init() {}
}
