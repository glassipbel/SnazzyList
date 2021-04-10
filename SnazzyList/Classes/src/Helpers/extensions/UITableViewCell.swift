//
//  UITableViewCell.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func setupBackground(backgroundColor: UIColor = .white) {
        self.selectionStyle = .none
        self.contentView.backgroundColor = backgroundColor
        self.backgroundColor = backgroundColor
    }
}
