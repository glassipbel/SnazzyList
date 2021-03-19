//
//  GenericTableActions.swift
//  Noteworth2
//
//  Created by Kevin on 3/28/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

import UIKit

@objc public protocol GenericTableActions: class {
    @objc optional func willEndDragging(scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    @objc optional func reachLastCellInTableView()
    @objc optional func reachFirstCellInTableView()
}
