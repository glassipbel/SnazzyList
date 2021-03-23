//
//  TableView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public enum TableSizingType {
    case specificHeight(CGFloat)
    case automatic
    case cell(GenericTableCellSelfSizingProtocol)
}
