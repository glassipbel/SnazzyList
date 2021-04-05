//
//  KMPlaceholderTextView.swift
//  Noteworth2
//
//  Created by Kevin on 12/21/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

extension KMPlaceholderTextView {
    convenience init(placeholderText: String = "", font: UIFont, textColor: UIColor = .black, backgroundColor: UIColor = .gray, borderStyle: UITextField.BorderStyle = UITextField.BorderStyle.line, borderColor: UIColor = .blue, placeholderTextColor: UIColor = .blue, insets: UIEdgeInsets = UIEdgeInsets(top: 14.0, left: 10.0, bottom: 14.0, right: 10.0), placeholderFont: UIFont? = nil) {
        self.init(frame: .zero)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.textColor = textColor
        self.tintColor = textColor
        self.backgroundColor = backgroundColor
        self.placeholderColor = placeholderTextColor
        self.placeholderFont = placeholderFont != nil ? placeholderFont! : font
        switch borderStyle {
        case .line:
            self.layer.borderWidth = 1.0
            self.layer.borderColor = borderColor.cgColor
        case .none:
            self.layer.borderWidth = 0.0
            self.layer.borderColor = nil
        default: break
        }
        self.textContainerInset = insets
        self.placeholder = placeholderText
    }
    
    func setPlaceholder(placeholder: String?) {
        guard let placeholder = placeholder else { return }
        self.placeholder = placeholder
    }
}
