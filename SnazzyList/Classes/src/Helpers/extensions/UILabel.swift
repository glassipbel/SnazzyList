//
//  UILabel.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        self.init(frame: CGRect.zero)
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addNormalLineSpacing(lineSpacing: CGFloat) {
        let oldText = self.text ?? ""
        
        let oldFont = self.font!
        let oldColor = self.textColor!
        let oldAlignment = self.textAlignment
        
        let style = NSMutableParagraphStyle()
        style.alignment = oldAlignment
        style.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: oldText)
        let range = NSMakeRange(0, attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.font, value: oldFont, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: oldColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        
        self.text = nil
        self.attributedText = attributedString
    }
    
    func addNormalLineSpacing(lineSpacing: CGFloat,
                              withLineBreakMode mode: NSLineBreakMode) {
        let oldText = self.text ?? ""
        
        let oldFont = self.font!
        let oldColor = self.textColor!
        let oldAlignment = self.textAlignment
        
        let style = NSMutableParagraphStyle()
        style.alignment = oldAlignment
        style.lineSpacing = lineSpacing
        style.lineBreakMode = mode
        
        let attributedString = NSMutableAttributedString(string: oldText)
        let range = NSMakeRange(0, attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.font, value: oldFont, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: oldColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        
        self.text = nil
        self.attributedText = attributedString
    }
    
    func addAttributedLineSpacing(lineSpacing: CGFloat, textAlignment: NSTextAlignment) {
        guard let attributed = self.attributedText else { return }
        
        let attributedString = NSMutableAttributedString(attributedString: attributed)
        let range = NSMakeRange(0, attributedString.length)
        
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineSpacing = lineSpacing
        
        attributedString.removeAttribute(NSAttributedString.Key.paragraphStyle, range: range)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        
        self.attributedText = attributedString
    }
    
    func addFontAfterNewLineCharacter(font: UIFont) {
        let oldText = self.text ?? ""
        guard let range = oldText.rangeOfCharacter(from: CharacterSet.newlines) else { return }
        
        let startPosition = oldText.distance(from: oldText.startIndex, to: range.lowerBound)
        if startPosition >= 0 && startPosition < oldText.count {
            let attributedString = NSMutableAttributedString(string: oldText)
            let range = NSMakeRange(startPosition, attributedString.length - startPosition)
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)

             self.text = nil
             self.attributedText = attributedString
        }
     }
}
