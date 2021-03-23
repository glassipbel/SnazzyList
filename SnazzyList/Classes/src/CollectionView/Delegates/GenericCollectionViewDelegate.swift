//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public class GenericCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var dataSource: GenericCollectionViewDataSource!
    weak var actions: GenericCollectionActions?
    
    public init(dataSource: GenericCollectionViewDataSource,
                isSelfSizing: Bool,
                insetsForSection: [Int: UIEdgeInsets]? = nil,
                minimumLineSpacingForSection: [Int: CGFloat]? = nil,
                minimumItemSpacingForSection: [Int: CGFloat]? = nil,
                actions: GenericCollectionActions? = nil) {
        self.actions = actions
        self.dataSource = dataSource
        self.insetsForSection = insetsForSection
        self.minimumLineSpacingForSection = minimumLineSpacingForSection
        self.minimumItemSpacingForSection = minimumItemSpacingForSection
        super.init()
        self.dataSource.collectionView.delegate = self
        if let layout = self.dataSource.collectionView.collectionViewLayout as? UICollectionViewFlowLayout, isSelfSizing {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    // MARK: - CollectionView Delegate Methods.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumLineSpacingForSection?[section] ?? (self.dataSource.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumItemSpacingForSection?[section] ?? (self.dataSource.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.item]
        
        switch configFile.sizingType {
        case .cell(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath, with: configFile.item).sizeMinOfZero
        case .specificSize(let size):
            return size.sizeMinOfZero
        case .specificHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height).sizeMinOfZero
        case .automatic:
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize(width: 50.0, height: 50.0)
        case .fullRowAutomatic:
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize(width: 50.0, height: 50.0)
        default:
            return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .header }).first else { return .zero }
        
        switch configFile.sizingType {
        case .header(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section, with: configFile.item).sizeMinOfZero
        case .headerFooterHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        case .headerFooterFullRowAutomatic:
            // Get the view for the first header
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

            // Use this view to calculate the optimal size based on the collection view's width
            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required, // Width is fixed
                                                      verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
        default:
            return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .footer }).first else { return .zero }
        
        switch configFile.sizingType {
        case .footer(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section, with: configFile.item).sizeMinOfZero
        case .headerFooterHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        case .headerFooterFullRowAutomatic:
            // Get the view for the first footer
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)

            // Use this view to calculate the optimal size based on the collection view's width
            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required, // Width is fixed
                                                      verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
        default:
            return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenericCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenericCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didDeselectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.configFiles.count == 0 { return }
        
        if checkIfReachLastCellInCollection(indexPath: indexPath) {
            actions?.reachLastCellInCollection?()
            actions?.reachLastCellInCollectionWithIndexPath?(indexPath: indexPath)
        }
        
        if checkIfReachLastSectionInCollection(indexPath: indexPath) {
            actions?.reachLastSectionInCollection?()
        }
        
        actions?.willDisplayCell?(indexPath: indexPath)
        
        guard let genericCell = cell as? GenericCollectionCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.item + 1 { return }
        
        let configFile = configFiles[indexPath.item]
        
        genericCell.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath, with: configFile.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let genericCell = cell as? GenericCollectionCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.item + 1 { return }
        
        let configFile = configFiles[indexPath.item]
        
        genericCell.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath, with: configFile.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let insets = insetsForSection else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        }
        return insets[section] ?? (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }

    private var insetsForSection: [Int: UIEdgeInsets]?
    private var minimumLineSpacingForSection: [Int: CGFloat]?
    private var minimumItemSpacingForSection: [Int: CGFloat]?
}

//MARK: - Util Public Methods
extension GenericCollectionViewDelegate {
    func cellOriginY(cell filter: @escaping (GenericCollectionCellConfigurator) -> Bool) -> CGFloat? {
        guard let index = dataSource.getIndexPath(by: filter) else { return nil }
        guard let superview = dataSource.collectionView.superview else { return nil }
        guard let atts = dataSource.collectionView.layoutAttributesForItem(at: index) else { return nil }
        let cellRect = atts.frame
        let origin = dataSource.collectionView.convert(cellRect, to: superview).origin
        return origin.y
    }
    
    func cellIsGoingOutWithProgress(offsetY additionalOffsetY: CGFloat = 0.0, cell filter: @escaping (GenericCollectionCellConfigurator) -> Bool) -> CGFloat? {
        guard let index = dataSource.getIndexPath(by: filter) else { return nil }
        guard let superview = dataSource.collectionView.superview else { return nil }
        guard let atts = dataSource.collectionView.layoutAttributesForItem(at: index) else { return nil }
        let cellRect = atts.frame
        let origin = dataSource.collectionView.convert(cellRect, to: superview).origin
        
        let offsetY = (origin.y - dataSource.collectionView.frame.origin.y - additionalOffsetY)
        if offsetY > 0 { return nil }
        let cellheight = cellRect.size.height
        if cellheight <= 0 { return nil }
        let absDis = abs(offsetY)
        return (absDis/cellheight)
    }
}

// MARK: - Private Inner Framework Methods
extension GenericCollectionViewDelegate {
    private func checkIfReachLastCellInCollection(indexPath: IndexPath) -> Bool {
        //Returning false because the user doesn't want to know if reached last cell in collection.
        if actions?.reachLastCellInCollection == nil && actions?.reachLastCellInCollectionWithIndexPath == nil { return false }
        
        let maxSection = dataSource.configFiles.map { $0.section }.sorted { $0 > $1 }.first
        let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
        
        if maxSection != indexPath.section { return false }
        if numberOfRowsInLastSection == 0 { return false }
        
        return lastRowComparation(indexPath: indexPath, numberOfRows: numberOfRowsInLastSection)
    }
    
    private func lastRowComparation(indexPath: IndexPath, numberOfRows: Int) -> Bool {
        if numberOfRows >= 3 {
            return indexPath.item == numberOfRows - 3
        } else if numberOfRows == 2 {
            return indexPath.item == numberOfRows - 2
        }
        return indexPath.item == numberOfRows - 1
    }
    
    private func checkIfReachLastSectionInCollection(indexPath: IndexPath) -> Bool {
        if actions?.reachLastSectionInCollection == nil { return false }
        
        let maxSection = dataSource.configFiles.map { $0.section }.sorted { $0 > $1 }.first ?? 0
        guard maxSection > 0 else { return false }
        // 10 is the number of sections before ending
        
        if maxSection == indexPath.section { return true }
        if maxSection - 2 == indexPath.section {
            let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
            return lastRowComparation(indexPath: indexPath, numberOfRows: numberOfRowsInLastSection)
        }
        
        return false
    }
}

extension GenericCollectionViewDelegate: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        actions?.didScroll?(scrollView: scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        actions?.willBeganScrolling?()
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        actions?.willEndDragging?(scrollView: scrollView, velocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    /**
     Assuming all pages are same size and paging is enabled.
     */
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let callback = actions?.didEndScrollingAtIndex else { return }
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
        
        callback(Int(round(offset/size)))
    }
}
