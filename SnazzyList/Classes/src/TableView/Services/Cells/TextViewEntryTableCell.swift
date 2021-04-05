//
//  TextViewEntryTableCell.swift
//  Dms
//
//  Created by Kevin on 9/25/18.
//  Copyright © 2018 DMS. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

/// This cell will fit the cases were you need to show a TextView so the user can enter information.
/// The size can be define for yours needs, it can also contain an scrim so you can use it as read only mode as well.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextViewEntryTableCell.png?raw=true
final class TextViewEntryTableCell: UITableViewCell {
    let entryTextView = KMPlaceholderTextView(font: UIFont.systemFont(ofSize: 17.0, weight: .medium))
    let scrimView = UIView(backgroundColor: UIColor.white.withAlphaComponent(0.6))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: TextViewEntryTableCellConfigFile?
}

extension TextViewEntryTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? TextViewEntryTableCellConfigFile else { return }
        self.configFile = configFile

        self.entryTextView.setPlaceholder(placeholder: configFile.placeholder)
        self.entryTextView.text = configFile.provider?.getTextViewEntryText(forIdentifier: configFile.identifier)
        self.entryTextView.font = configFile.entryTextFont
        self.entryTextView.textColor = configFile.entryTextColor
        self.entryTextView.isUserInteractionEnabled = configFile.isEditable
        self.entryTextView.spellCheckingType = configFile.spellChecking ? .yes : .no
        scrimView.isHidden = configFile.isEditable
    }
}

extension TextViewEntryTableCell {
    private func setupViews() {
        setupBackground()
        setupEntryTextView()
        setupScrimView()
    }
    
    private func setupEntryTextView() {
        entryTextView.layer.cornerRadius = 4.0
        entryTextView.delegate = self
        contentView.addSubview(entryTextView)
    }
    
    private func setupScrimView() {
        contentView.addSubview(scrimView)
    }
    
    private func setupConstraints() {
        entryTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
        entryTextView.bind(withConstant: 16.0, boundType: .horizontal)
        entryTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0).isActive = true
        
        scrimView.bind(withConstant: 0.0, boundType: .full)
    }
}

extension TextViewEntryTableCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let configFile = self.configFile else { return true }
        configFile.actions?.onTextViewEntryTapped?(forIdentifier: configFile.identifier)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let configFile = self.configFile else { return true }
        
        let maxLength = configFile.maxLength ?? Int.max
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        if newString.length <= maxLength {
            configFile.actions?.onTextViewEntryChanged(text: newString as String, forIdentifier: configFile.identifier)
            return true
        } else {
            return false
        }
    }
}

struct TextViewEntryTableCellConfigFile {
    let identifier: Any
    let entryTextFont: UIFont
    let entryTextColor: UIColor
    let isEditable: Bool
    let placeholder: String
    let maxLength: Int?
    let spellChecking: Bool
    
    weak var provider: TextViewEntryTableProvider?
    weak var actions: TextViewEntryTableActions?
    
    init(identifier: Any, entryTextFont: UIFont, entryTextColor: UIColor, placeholder: String, maxLength: Int?, isEditable: Bool, spellChecking: Bool, provider: TextViewEntryTableProvider?, actions: TextViewEntryTableActions?) {
        self.identifier = identifier
        self.entryTextFont = entryTextFont
        self.entryTextColor = entryTextColor
        self.isEditable = isEditable
        self.placeholder = placeholder
        self.maxLength = maxLength
        self.spellChecking = spellChecking
        self.provider = provider
        self.actions = actions
    }
}

public protocol TextViewEntryTableProvider: class {
    func getTextViewEntryText(forIdentifier identifier: Any) -> String?
}

@objc public protocol TextViewEntryTableActions: class {
    func onTextViewEntryChanged(text: String, forIdentifier identifier: Any)
    @objc optional func onTextViewEntryTapped(forIdentifier identifier: Any)
}
