//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

@objc public protocol GenericCollectionActions: class {
    @objc optional func reachLastCellInCollection()
    @objc optional func reachLastCellInCollectionWithIndexPath(indexPath: IndexPath)
    @objc optional func reachLastSectionInCollection()
    @objc optional func didEndScrollingAtIndex(index: Int)
    @objc optional func didScroll(scrollView: UIScrollView)
    @objc optional func willEndDragging(scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    @objc optional func willDisplayCell(indexPath: IndexPath)
    @objc optional func willBeganScrolling()
}
