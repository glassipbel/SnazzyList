//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/// An instance of `SnazzyCollectionViewDelegate` is responsable for responding the methods that the collection view needs in order to display all the cells properly. You must have this instance in your desired `UIViewController`.
public class SnazzyCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /**
     Creates a new instance of the `SnazzyCollectionViewDelegate`.
     - parameter dataSource: The `SnazzyCollectionViewDataSource` that you instantiated in your `UIViewController`.
     - parameter reachLastCellInCollection: An optional callback that will be called when the user reachs the last cell in the `UICollectionView`.
     - parameter reachLastSectionInCollection: An optional callback that will be called when the user reachs the last section in the `UICollectionView`.
     - parameter didEndScrollingAtIndex: An optional callback that will be called when the `UICollectionView` stops scrolling.
     - parameter didScroll: An optional callback what will be called when the `UICollectionView` scrolls.
     - parameter willDisplayCell: An optional callback that will be called for every cell when it will be displayed.
     - parameter willBeganScrolling: An optional callback that will be called when the `UICollectionView` began scrolling.
     - returns: An Instance of `SnazzyCollectionViewDelegate`
     */
    public init(
        dataSource: SnazzyCollectionViewDataSource,
        reachLastCellInCollection: (()->())? = nil,
        reachLastSectionInCollection: (()->())? = nil,
        didEndScrollingAtIndex: ((Int) ->())? = nil,
        didScroll: ((UIScrollView) -> ())? = nil,
        willDisplayCell: ((IndexPath)->())? = nil,
        willBeganScrolling: (()->())? = nil) {
        self.dataSource = dataSource
        self.reachLastCellInCollection = reachLastCellInCollection
        self.didEndScrollingAtIndex = didEndScrollingAtIndex
        self.reachLastSectionInCollection = reachLastSectionInCollection
        self.didScroll = didScroll
        self.willDisplayCell = willDisplayCell
        self.willBeganScrolling = willBeganScrolling
        super.init()
        self.dataSource.collectionView.delegate = self
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.item]
        
        switch configFile.sizingType {
        case .cell(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath, with: configFile.item)
        case .specificSize(let size):
            return size
        case .specificHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        default:
            return .zero
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .header }).first else { return .zero }
        
        switch configFile.sizingType {
        case .header(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section, with: configFile.item)
        case .specificSize(let size):
            return size
        case .specificHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        default:
            return .zero
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .footer }).first else { return .zero }
        
        switch configFile.sizingType {
        case .footer(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section, with: configFile.item)
        case .specificSize(let size):
            return size
        case .specificHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        default:
            return .zero
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SnazzyCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didSelectItemAt: indexPath)
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SnazzyCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didDeselectItemAt: indexPath)
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.configFiles.count == 0 { return }
        
        if checkIfReachLastCellInCollection(indexPath: indexPath) {
            reachLastCellInCollection?()
        }
        
        if checkIfReachLastSectionInCollection(indexPath: indexPath) {
            reachLastSectionInCollection?()
        }
        
        willDisplayCell?(indexPath)
        
        guard let genericCell = cell as? SnazzyCollectionCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.item + 1 { return }
        
        let configFile = configFiles[indexPath.item]
        
        genericCell.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath, with: configFile.item)
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let genericCell = cell as? SnazzyCollectionCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.item + 1 { return }
        
        let configFile = configFiles[indexPath.item]
        
        genericCell.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath, with: configFile.item)
    }

    weak fileprivate var dataSource: SnazzyCollectionViewDataSource!
    fileprivate var reachLastCellInCollection: (()->())?
    fileprivate var reachLastSectionInCollection: (()->())?
    fileprivate var didEndScrollingAtIndex: ((Int)->())?
    fileprivate var didScroll: ((UIScrollView)->())?
    fileprivate var willDisplayCell: ((IndexPath)->())?
    fileprivate var willBeganScrolling: (()->())?
}

extension SnazzyCollectionViewDelegate: UIScrollViewDelegate {
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.willBeganScrolling?()
    }
}

extension SnazzyCollectionViewDelegate {
    /**
     This method will return the offset of the cell specified in the filter parameter.
     - parameter offsetY: You must provide the offsetY of the `UICollectionView` regarding to its superview.
     For example if the `UICollectionView` has a topAnchor to its superview of 30 points, then you should pass the 30 in the offsetY parameter.
     Otherwise if the `UICollectionView` has a topAnchor equal its superview, then you don't need to pass any value in this parameter.
     - parameter cell: Closure that indicates what cell this method should track its progress.
     - returns: The progress of the cell from the origin of the `UICollectionView`.
     
     */
    public func cellIsGoingOutWithProgress(offsetY additionalOffsetY: CGFloat = 0.0, cell filter: @escaping (SnazzyCollectionCellConfigurator) -> Bool) -> CGFloat? {
        guard let index = dataSource.getIndexPath(by: filter) else { return nil }
        guard let superview = dataSource.collectionView.superview else { return nil }
        guard let atts = dataSource.collectionView.layoutAttributesForItem(at: index) else { return nil }
        let cellRect = atts.frame
        let origin = dataSource.collectionView.convert(cellRect, to: superview).origin
        
        let offsetY = (origin.y - dataSource.collectionView.frame.origin.y - additionalOffsetY)
        let cellheight = cellRect.size.height
        let absDis = abs(offsetY)
        return (absDis/cellheight)
    }
    
    fileprivate func cellOriginY(cell filter: @escaping (SnazzyCollectionCellConfigurator) -> Bool) -> CGFloat? {
        guard let index = dataSource.getIndexPath(by: filter) else { return nil }
        guard let superview = dataSource.collectionView.superview else { return nil }
        guard let atts = dataSource.collectionView.layoutAttributesForItem(at: index) else { return nil }
        let cellRect = atts.frame
        let origin = dataSource.collectionView.convert(cellRect, to: superview).origin
        return origin.y
    }
    
    fileprivate func checkIfReachLastCellInCollection(indexPath: IndexPath) -> Bool {
        //Returning false because the user doesn't want to know if reached last cell in collection.
        if reachLastCellInCollection == nil { return false }
        
        let maxSection = dataSource.configFiles.map { $0.section }.sorted { $0.0 > $0.1 }.first
        let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
        
        if maxSection != indexPath.section { return false }
        if numberOfRowsInLastSection == 0 { return false }
        
        return lastRowComparation(indexPath: indexPath, numberOfRows: numberOfRowsInLastSection)
    }
    
    fileprivate func lastRowComparation(indexPath: IndexPath, numberOfRows: Int) -> Bool {
        if numberOfRows >= 3 {
            if indexPath.item == numberOfRows - 3 {
                return true
            }
        } else if numberOfRows == 2 {
            if indexPath.item == numberOfRows - 2 {
                return true
            }
        } else {
            if indexPath.item == numberOfRows - 1 {
                return true
            }
        }
        return false
    }
    
    fileprivate func checkIfReachLastSectionInCollection(indexPath: IndexPath) -> Bool {
        if reachLastSectionInCollection == nil { return false }
        
        let maxSection = dataSource.configFiles.map {$0.section}.sorted {$0.0 > $0.1}.first
        
        guard let sectionGap = maxSection else { return false }
        
        if sectionGap - 1 == indexPath.section {
            let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
            return lastRowComparation(indexPath: indexPath, numberOfRows: numberOfRowsInLastSection)
        }
        
        return false
    }
}
