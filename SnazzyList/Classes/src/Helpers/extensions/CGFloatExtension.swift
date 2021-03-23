//
//  CGFloatExtension.swift
//  Noteworth2
//
//  Created by Kevin on 11/05/20.
//  Copyright © 2020 Noteworth. All rights reserved.
//

import UIKit

extension CGFloat {
    var sizeMinOfZero: CGFloat {
        return self > 0.0 ? self : 0.0
    }
}
