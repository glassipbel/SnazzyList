//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//
import UIKit

/**
 An option for what kind of sizing option you want for every configFile.
 */
public enum SnazzyCollectionSizingType {
    case specificSize(CGSize)
    case specificHeight(CGFloat)
    case cell(SnazzyCollectionCellSelfSizingProtocol)
    case header(SnazzyCollectionHeaderSelfSizingProtocol)
    case footer(SnazzyCollectionFooterSelfSizingProtocol)
}
