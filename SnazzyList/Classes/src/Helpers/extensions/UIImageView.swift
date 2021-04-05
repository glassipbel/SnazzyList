//
//  UIImageView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init(image: image)
        self.contentMode = contentMode
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.isAccessibilityElement = true
    }
}
