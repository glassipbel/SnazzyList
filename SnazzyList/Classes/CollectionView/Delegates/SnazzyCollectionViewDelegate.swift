//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

public class SnazzyCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SnazzyCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SnazzyCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didDeselectItemAt: indexPath)
    }
    
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
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let genericCell = cell as? SnazzyCollectionCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.item + 1 { return }
        
        let configFile = configFiles[indexPath.item]
        
        genericCell.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath, with: configFile.item)
    }

    weak public var dataSource: SnazzyCollectionViewDataSource!
    public var reachLastCellInCollection: (()->())?
    public var reachLastSectionInCollection: (()->())?
    fileprivate var didEndScrollingAtIndex: ((Int)->())?
    fileprivate var didScroll: ((UIScrollView)->())?
    fileprivate var willDisplayCell: ((IndexPath)->())?
    fileprivate var willBeganScrolling: (()->())?
}

extension SnazzyCollectionViewDelegate: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.willBeganScrolling?()
    }
}

extension SnazzyCollectionViewDelegate {
    public func cellOriginY(cell filter: @escaping (SnazzyCollectionCellConfigurator) -> Bool) -> CGFloat? {
        guard let index = dataSource.getIndexPath(by: filter) else { return nil }
        guard let superview = dataSource.collectionView.superview else { return nil }
        guard let atts = dataSource.collectionView.layoutAttributesForItem(at: index) else { return nil }
        let cellRect = atts.frame
        let origin = dataSource.collectionView.convert(cellRect, to: superview).origin
        return origin.y
    }
    
    public func cellIsGoingOutWithProgress(offsetY additionalOffsetY: CGFloat = 0.0, cell filter: @escaping (SnazzyCollectionCellConfigurator) -> Bool) -> CGFloat? {
        guard let index = dataSource.getIndexPath(by: filter) else { return nil }
        guard let superview = dataSource.collectionView.superview else { return nil }
        guard let atts = dataSource.collectionView.layoutAttributesForItem(at: index) else { return nil }
        let cellRect = atts.frame
        let origin = dataSource.collectionView.convert(cellRect, to: superview).origin
        
        let offsetY = (origin.y - dataSource.collectionView.frame.origin.y - additionalOffsetY)
        if offsetY > 0 { return nil }
        let cellheight = cellRect.size.height
        let absDis = abs(offsetY)
        return (absDis/cellheight)
    }
    
    /**
     Assuming all pages are same size and paging is enabled.
     */
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let callback = didEndScrollingAtIndex else { return }
        if !scrollView.isPagingEnabled { return }
        if dataSource.configFiles.count == 0 { return }
        guard let flowLayout = dataSource.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let fullSize = flowLayout.scrollDirection == .horizontal ?
            dataSource.collectionView.contentSize.width :
            dataSource.collectionView.contentSize.height
        
        let size = fullSize / CGFloat(dataSource.configFiles.count)
        
        let offset = flowLayout.scrollDirection == .horizontal ?
            scrollView.contentOffset.x :
            scrollView.contentOffset.y
        
        callback(Int(offset/size))
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
        
        if sectionGap - 3 == indexPath.section {
            let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
            return lastRowComparation(indexPath: indexPath, numberOfRows: numberOfRowsInLastSection)
        }
        
        return false
    }
}
