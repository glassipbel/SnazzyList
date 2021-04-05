//
//  UITextField.swift
//  Noteworth2
//
//  Created by Kevin on 12/21/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UITextField {
    convenience init(placeholderText: String? = nil, font: UIFont, textColor: UIColor = .black, backgroundColor: UIColor = .gray, borderStyle: UITextField.BorderStyle = UITextField.BorderStyle.line, borderColor: UIColor = .blue, placeholderTextColor: UIColor = .blue, placeholderFont: UIFont? = nil, paddingLeft: CGFloat = 14.0, paddingRight: CGFloat = 14.0) {
        self.init(frame: .zero)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.textColor = textColor
        self.borderStyle = .none
        self.tintColor = textColor
        self.setBorder(borderStyle: borderStyle, borderColor: borderColor)
        self.backgroundColor = backgroundColor
        self.setPlaceholder(placeholder: placeholderText, placeholderFont: placeholderFont, placeholderColor: placeholderTextColor)
        
        let paddingLeftView = UIView(frame: CGRect(x: 0, y: 0, width: paddingLeft, height: 1.0))
        self.leftView = paddingLeftView
        self.leftViewMode = .always
        
        let paddingRightView = UIView(frame: CGRect(x: 0, y: 0, width: paddingRight, height: 1.0))
        self.rightView = paddingRightView
        self.rightViewMode = .always
    }
    
    func setPlaceholder(placeholder: String?, placeholderFont: UIFont?, placeholderColor: UIColor) {
        guard let placeholder = placeholder, let font = self.font else { return }
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: placeholderColor,
                NSAttributedString.Key.font: placeholderFont ?? font
            ]
        )
    }
    
    func setBorder(borderStyle: UITextField.BorderStyle, borderColor: UIColor) {
        switch borderStyle {
        case .line:
            self.layer.borderWidth = 1.0
            self.layer.borderColor = borderColor.cgColor
        case .none:
            self.layer.borderWidth = 0.0
            self.layer.borderColor = nil
        default: break
        }
    }
    
    func configurePaddingRight(padding: CGFloat = 14.0) {
        let paddingRightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 1.0))
        self.rightView = paddingRightView
        self.rightViewMode = .always
    }
    
    func configureLeftViewWithIcon(icon: UIImage, horizontalMargin: CGFloat = 8.0) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: icon.size.width + horizontalMargin * 2, height: icon.size.height))
        imageView.contentMode = .center
        imageView.image = icon
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width:icon.size.width + horizontalMargin * 2, height: icon.size.height))
        leftView.addSubview(imageView)
        self.leftView = leftView
        self.leftViewMode = .always
    }
}
