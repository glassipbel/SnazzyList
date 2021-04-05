//
//  UIStackView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat) {
        self.init(frame: .zero)
        
        self.axis = axis
        self.clipsToBounds = true
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
