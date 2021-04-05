//
//  NSString+Extension.swift
//  Noteworth2
//
//  Created by Olga Matsyk on 19/3/21.
//  Copyright © 2021 Noteworth2. All rights reserved.
//

import Foundation

// MARK: - Range
extension NSString {
    func hasRange(_ range: NSRange) -> Bool {
        return  range.location != NSNotFound && NSMaxRange(range) <= self.length
    }
}
