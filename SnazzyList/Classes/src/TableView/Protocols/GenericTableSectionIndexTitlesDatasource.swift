//
//  TableView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import Foundation

public protocol GenericTableSectionIndexTitlesDatasource: class {
    var sectionIndexTitles: [String]? { get }
    func sectionForSectionIndexTitle(title: String, at index: Int) -> Int
}
