//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public enum SizingType {
    // MARK: - Manual Cells.
    /// The property isSelfSizing on the delegate must be false in order to use option.
    case specificSize(CGSize)
    
    /// The property isSelfSizing on the delegate must be false in order to use option.
    case specificHeight(CGFloat)
    
    /// The property isSelfSizing on the delegate must be false in order to use option.
    case cell(GenericCollectionCellSelfSizingProtocol)
    
    // MARK: - Self Sizing Cells.
    /// For this option your cell must inherit from CollectionViewSelfSizingCell and the property isSelfSizing on the delegate must be set to true.
    case automatic(width: CGFloat)
    /// For this option your cell must inherit from CollectionViewSelfSizingCell and the property isSelfSizing on the delegate must be set to true.
    case fullRowAutomatic
    
    // MARK: - Headers & Footers
    /// This option is only valid for header and footers. For this option your reusable view must inherit from CollectionReusableSelfSizingView.
    case headerFooterFullRowAutomatic
    
    /// This option is only valid for header and footers.
    case headerFooterHeight(height: CGFloat)
    
    /// This option is only valid for headers.
    case header(GenericCollectionHeaderSelfSizingProtocol)
    
    /// This option is only valid for footers.
    case footer(GenericCollectionFooterSelfSizingProtocol)
}
