//
//  CGSizeExtension.swift
//  Noteworth2
//
//  Created by Kevin on 11/05/20.
//  Copyright © 2020 Noteworth. All rights reserved.
//

import UIKit

extension CGSize {
    var sizeMinOfZero: CGSize {
        var finalWidth: CGFloat = 0.0
        var finalHeight: CGFloat = 0.0
        
        if self.width > 0.0 {
            finalWidth = self.width
        }
        
        if self.height > 0.0 {
            finalHeight = self.height
        }
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
}
