//
//  String.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

extension Optional where Wrapped == String {
  var isEmptyString: Bool {
    guard let value = self else { return true }
    return value.replacingOccurrences(of: " ", with: "") == ""
  }
}

extension String {
    var isEmptyString: Bool {
      return self.replacingOccurrences(of: " ", with: "") == ""
    }
    
    func trunc(length: Int, trailing: String = "…") -> String {
        (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    func attributed(type: NSAttributedString.DocumentType) -> NSAttributedString? {
        guard let data = self.data(using: .utf8),
            let result = try? NSAttributedString(data: data,
                                                 options: [.documentType: type],
                                                 documentAttributes: nil) else { return nil }
        return result
    }
    
    static func getAttributedStringWithMultilines(texts: [(String, UIFont, UIColor)], lineSpacing: CGFloat = 4.0, alignment: NSTextAlignment = .left) -> NSAttributedString {
        
        let fullAttributedText = NSMutableAttributedString()
        
        for (index, attributes) in texts.enumerated() {
            let titleAttributed = NSMutableAttributedString(string: attributes.0)
            let titleRange = NSMakeRange(0, titleAttributed.length)
            titleAttributed.addAttribute(NSAttributedString.Key.font, value: attributes.1, range: titleRange)
            titleAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: attributes.2, range: titleRange)
            fullAttributedText.append(titleAttributed)
            if index == texts.count - 1 { continue }
            fullAttributedText.append(NSAttributedString(string: "\n"))
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineSpacing = lineSpacing
        
        fullAttributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, fullAttributedText.length))
        
        return fullAttributedText
    }
    
    func getAttributedStringWithMatchingStringWithAnotherFont(matchString: String, normalFont: UIFont, matchFont: UIFont, normalTextColor: UIColor, matchTextColor: UIColor, normalBackground: UIColor? = nil, matchBackground: UIColor? = nil) -> NSMutableAttributedString {
        
        return getAttributedStringWithMatchingStringsWithAnotherFont(matchStrings: [matchString], normalFont: normalFont, matchFont: matchFont, normalTextColor: normalTextColor, matchTextColor: matchTextColor, normalBackground: normalBackground, matchBackground: matchBackground)
    }
    
    func getAttributedStringWithMatchingStringsWithAnotherFont(matchStrings: [String], normalFont: UIFont, matchFont: UIFont, normalTextColor: UIColor, matchTextColor: UIColor, normalBackground: UIColor? = nil, matchBackground: UIColor? = nil) -> NSMutableAttributedString {
        
        let fullTextLowercased = self.lowercased()
        let fullTextAttributed = NSMutableAttributedString(string: self)
        let fullTextNSLowercased = NSString(string: fullTextLowercased)
        let fullRange = NSMakeRange(0, fullTextAttributed.length)
        
        var rangesMatches = [NSRange]()
        var rangeSearched = NSMakeRange(0, fullTextAttributed.length)
        for matchString in matchStrings {
            rangeSearched = NSMakeRange(0, fullTextAttributed.length)
            while rangeSearched.location != NSNotFound {
                rangeSearched = fullTextNSLowercased.range(of: matchString.lowercased(), options: NSString.CompareOptions(rawValue: 0), range: rangeSearched)
                if rangeSearched.location == NSNotFound { break }
                
                rangesMatches.append(NSMakeRange(rangeSearched.location, rangeSearched.length))
                rangeSearched = NSMakeRange(rangeSearched.location + rangeSearched.length, NSString(string: self).length - (rangeSearched.location + rangeSearched.length))
            }
        }
        
        fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: normalFont, range: fullRange)
        fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: normalTextColor, range: fullRange)
        if let color = normalBackground {
            fullTextAttributed.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: fullRange)
        }
        
        for range in rangesMatches {
            fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: matchFont, range: range)
            fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTextColor, range: range)
            if let color = matchBackground {
                fullTextAttributed.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
            }
        }
        
        return fullTextAttributed
    }
    
    func getAttributedStringWithTwoGroupsMatchingStringsWithAnotherFont(matchStrings1: [String], matchStrings2: [String], normalFont: UIFont, matchFont1: UIFont, matchFont2: UIFont, normalTextColor: UIColor, matchTextColor1: UIColor, matchTextColor2: UIColor) -> NSMutableAttributedString {
        
        let fullTextLowercased = self.lowercased()
        let fullTextAttributed = NSMutableAttributedString(string: self)
        let fullTextNSLowercased = NSString(string: fullTextLowercased)
        let fullRange = NSMakeRange(0, fullTextAttributed.length)
        
        var rangesMatches1 = [NSRange]()
        var rangeSearched1 = NSMakeRange(0, fullTextAttributed.length)
        for matchString in matchStrings1 {
            rangeSearched1 = NSMakeRange(0, fullTextAttributed.length)
            while rangeSearched1.location != NSNotFound {
                rangeSearched1 = fullTextNSLowercased.range(of: matchString.lowercased(), options: NSString.CompareOptions(rawValue: 0), range: rangeSearched1)
                if rangeSearched1.location == NSNotFound { break }
                
                rangesMatches1.append(NSMakeRange(rangeSearched1.location, rangeSearched1.length))
                rangeSearched1 = NSMakeRange(rangeSearched1.location + rangeSearched1.length, NSString(string: self).length - (rangeSearched1.location + rangeSearched1.length))
            }
        }
        
        var rangesMatches2 = [NSRange]()
        var rangeSearched2 = NSMakeRange(0, fullTextAttributed.length)
        for matchString in matchStrings2 {
            rangeSearched1 = NSMakeRange(0, fullTextAttributed.length)
            while rangeSearched2.location != NSNotFound {
                rangeSearched2 = fullTextNSLowercased.range(of: matchString.lowercased(), options: NSString.CompareOptions(rawValue: 0), range: rangeSearched2)
                if rangeSearched2.location == NSNotFound { break }
                
                rangesMatches2.append(NSMakeRange(rangeSearched2.location, rangeSearched2.length))
                rangeSearched2 = NSMakeRange(rangeSearched2.location + rangeSearched2.length, NSString(string: self).length - (rangeSearched2.location + rangeSearched2.length))
            }
        }
        
        fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: normalFont, range: fullRange)
        fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: normalTextColor, range: fullRange)
        
        for range in rangesMatches1 {
            fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: matchFont1, range: range)
            fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTextColor1, range: range)
        }
        
        for range in rangesMatches2 {
            fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: matchFont2, range: range)
            fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTextColor2, range: range)
        }
        
        return fullTextAttributed
    }
    
    func getAttributedStringWithTwoMatchingStringsWithAnotherFont(normalFont: UIFont, normalColor: UIColor, firstMatch: String, secondMatch: String, firstFont: UIFont, secondFont: UIFont, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
        
        let fullTextAttributed = NSMutableAttributedString(string: self)
        let fullTextNS = NSString(string: self)
        let firstRange = fullTextNS.range(of: firstMatch)
        let secondRange = fullTextNS.range(of: secondMatch)
        let fullRange = NSMakeRange(0, fullTextAttributed.length)
        
        fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: normalFont, range: fullRange)
        fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: normalColor, range: fullRange)
        
        fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: firstFont, range: firstRange)
        fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor, range: firstRange)
        
        fullTextAttributed.addAttribute(NSAttributedString.Key.font, value: secondFont, range: secondRange)
        fullTextAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor, range: secondRange)
        
        return fullTextAttributed
    }
    
    func asAttributedString(font: UIFont, color: UIColor, strike: Bool = false, underline: Bool = false) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        
        if strike {
            attributes[NSAttributedString.Key.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        
        if underline {
            attributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func asAttributedString(font: UIFont, color: UIColor, strike: Bool = false, underline: Bool = false, alignment: NSTextAlignment, lineSpacing: CGFloat) -> NSMutableAttributedString {
        let att = self.asAttributedString(font: font, color: color, strike: strike, underline: underline)
        
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineSpacing = lineSpacing
        
        att.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, att.length))
        return att
    }
    
    func getAttributedStringWithLetterSpacing(spacing: CGFloat, font: UIFont, color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.kern: spacing,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
        )
    }
    
    func getAttributedStringWithLetterSpacing(spacing: CGFloat) -> NSAttributedString {
        return NSMutableAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.kern: spacing,
                ]
        )
    }
}

extension String {
    func getDate(withFormat format: String, timeZone: TimeZone) -> Date? {
        return DateFormatter.getDefaultFormatter(format: format, timeZone: timeZone).date(from: self)
    }
    
    func getDate(withFormat format: String) -> Date? {
        return DateFormatter.getDefaultFormatter(format: format).date(from: self)
    }
    
    func getBasicDate() -> Date? {
        return self.getDate(withFormat: "yyyy-MM-dd")
    }
    
    func getTime() -> TimeInterval? {
        guard let midnight = DateFormatter.getDefaultFormatter(format: "HH:mm").date(from: "00:00") else { return nil }
        var time: Date?
        if let time12H = DateFormatter.getDefaultFormatter(format: "hh:mm a").date(from: self) {
            time = time12H
        } else if let time24H  = DateFormatter.getDefaultFormatter(format: "HH:mm").date(from: self) {
            time = time24H
        }
        return time?.timeIntervalSince(midnight)
    }
    
    func getCompleteDate(with timeString: String? = nil) -> Date? {
        let date = DateFormatter.getDefaultFormatter(format: "MM/dd/yyyy").date(from: self)
        guard let time = timeString?.getTime() else { return date }
        
        return date?.addingTimeInterval(time)
    }
    
    func getLocalTimeFromUTCTimestamp() -> Date? {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
        
        if dateFormatter.date(from: self) == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        }
        
        if dateFormatter.date(from: self) == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        
        if dateFormatter.date(from: self) == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmssZZZZZ"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        
        return dateFormatter.date(from: self)
    }
    
//    func getLocalHourFromUTCTimestamp() -> Date? {
//        let dateFormatter = DateFormatter.getDefaultFormatter(format: "hh:mma")
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        return dateFormatter.date(from: self)
//    }
    
    func getDateFromTimestamp(utcOffset: String?) -> Date? {
        let dateFormatter = DateFormatter.getDefaultFormatter(
            format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            timeZone: TimeZone(abbreviation: utcOffset ?? "GMT+0:00")
        )
        
        if dateFormatter.date(from: self) == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        }
        return dateFormatter.date(from: self)
    }
    
    func getStartDateFromTimestamp(utcOffset: String?) -> Date? {
        return DateFormatter.getDefaultFormatter(
            format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            timeZone: TimeZone(abbreviation: utcOffset ?? "GMT+0:00")
        ).date(from: self)
    }
}

extension String {
    func isValidName() -> Bool {
        let selfWithoutSpaces = self.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        return selfWithoutSpaces.isValidAgainst(regex: "^[a-zA-Z]+$") && selfWithoutSpaces != ""
    }
    
    func isValidNumber() -> Bool {
        let selfWithoutSpaces = self.replacingOccurrences(of: " ", with: "")
        return selfWithoutSpaces.isValidAgainst(regex: "^[0-9]*$") && selfWithoutSpaces.count == 10
    }
    
    func isValidEmail() -> Bool {
        return isValidAgainst(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    func isValidAgainst(regex: String?) -> Bool {
        guard let regex = regex else { return true }
        let regexTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return regexTest.evaluate(with: self)
    }
    
    func withPhoneAdditions() -> String {
        let formatter = TextFormatter(textPattern: "(###) ###-####")
        return "+1 " + (formatter.formattedText(from: self) ?? self)
    }
    
    func formattedPhone() -> String {
        let formatter = TextFormatter(textPattern: "(###) ###-####")
        return (formatter.formattedText(from: self) ?? self)
    }
    
    func isValidPassword() -> Bool {
        return isValidAgainst(regex: "^(?=.*[0-9])(?=.*[A-Za-z])(?=.*[!\"#$%&'()*+,\\-./:;<=>?@\\[\\]^_`{|}~])(?=\\S+$).{8,}$")
    }
}

extension String {
    mutating func cleanPhoneAdditions() {
        self = self.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+1", with: "")
    }
    
    mutating func cleanPhone() {
        self = self.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }
    
    var stripHTMLBasicURL: String {
        return self.lowercased().replacingOccurrences(of: "www.", with: "").replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension String {
    func removingAllWhitespaces() -> String {
        return removingCharacters(from: .whitespaces)
    }

    func removingCharacters(from set: CharacterSet) -> String {
        var newString = self
        newString.removeAll { char -> Bool in
            guard let scalar = char.unicodeScalars.first else { return false }
            return set.contains(scalar)
        }
        return newString
    }
}
