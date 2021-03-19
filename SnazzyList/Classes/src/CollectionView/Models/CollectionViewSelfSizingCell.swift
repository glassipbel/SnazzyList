//
//  CollectionViewSelfSizing.swift
//  Noteworth2
//
//  Created by Kevin on 21/04/20.
//  Copyright © 2020 Noteworth. All rights reserved.
//

import UIKit

class CollectionViewSelfSizingCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }
    
    private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }
}

private extension CollectionViewSelfSizingCell {
    private func setupViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        contentView.bind(withConstant: 0.0, boundType: .full)
        
        self.maxWidthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: 50.0)
    }
}
