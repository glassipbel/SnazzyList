//
//  UIButton.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UIButton {
    static func getInvisible(target: Any?, action: Selector) -> UIButton {
        let button = UIButton(frame: .zero)
        button.clipsToBounds = true
        button.addTarget(target, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }
    
    convenience init(font: UIFont, titleColor: UIColor, title: String, backgroundColor: UIColor, underline: Bool = false) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: UIControl.State())
        self.setTitleColor(titleColor, for: UIControl.State())
        self.backgroundColor = backgroundColor
        self.titleLabel!.font = font
        self.clipsToBounds = true
        self.titleLabel?.lineBreakMode = .byWordWrapping
        
        if underline {
            let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: titleColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            let attributedString = NSMutableAttributedString(string: title,
            attributes: yourAttributes)
            
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    convenience init(image: UIImage, contentMode: UIView.ContentMode) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(image, for: .normal)
        self.imageView?.contentMode = contentMode
    }
}
