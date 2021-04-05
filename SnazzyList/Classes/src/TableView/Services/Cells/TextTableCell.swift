//
//  TextTableCell.swift
//  Dms
//
//  Created by Kevin on 10/5/18.
//  Copyright © 2018 DMS. All rights reserved.
//

import UIKit

/// This cell will fit the cases were you need to show a Text for the user, but it may change depending on something else on the screen, in that case this will be a good fit, because you can pass the text dinamycally and just by reloading the tableview it will be displayed.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextTableCell.png?raw=true
final class TextTableCell: UITableViewCell {
    let titleLabel = UILabel(font: .systemFont(ofSize: 17.0, weight: .medium), textColor: .gray, textAlignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    private var configFile: TextTableCellConfigFile?
}

extension TextTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? TextTableCellConfigFile else { return }
        guard let type = configFile.provider?.getTextTableText(forIdentifier: configFile.identifier) else { return }
        self.configFile = configFile
        
        leftConstraint?.constant = configFile.leftMargin
        rightConstraint?.constant = configFile.rightMargin
        topConstraint?.constant = configFile.topMargin
        bottomConstraint?.constant = configFile.bottomMargin
        contentView.backgroundColor = configFile.backgroundColor
        
        switch type {
        case .attributed(let attributedText):
            titleLabel.text = nil
            titleLabel.attributedText = attributedText
            
        case .normal(let text, let font, let titleColor, let textAlignment):
            titleLabel.attributedText = nil
            titleLabel.font = font
            titleLabel.text = text
            titleLabel.textColor = titleColor
            titleLabel.textAlignment = textAlignment
        
        case .none:
            titleLabel.text = nil
            titleLabel.attributedText = nil
        }
        
        layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.tapTextTable(forIdentifier: configFile.identifier)
    }
}

extension TextTableCell {
    private func setupViews() {
        setupBackground()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        leftConstraint = titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24.0)
        leftConstraint?.isActive = true
        rightConstraint = contentView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 24.0)
        rightConstraint?.isActive = true
        
        topConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0)
        topConstraint?.isActive = true
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0.0)
        bottomConstraint?.isActive = true
    }
}

public enum TextTableCellType {
    case attributed(text: NSAttributedString)
    case normal(text: String, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment)
    case none
}

struct TextTableCellConfigFile {
    let identifier: Any
    let backgroundColor: UIColor
    let leftMargin: CGFloat
    let rightMargin: CGFloat
    let topMargin: CGFloat
    let bottomMargin: CGFloat
    
    weak var provider: TextTableProvider?
    weak var actions: TextTableActions?
    
    init(identifier: Any, backgroundColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat, topMargin: CGFloat, bottomMargin: CGFloat, provider: TextTableProvider?, actions: TextTableActions?) {
        self.identifier = identifier
        self.backgroundColor = backgroundColor
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        
        self.provider = provider
        self.actions = actions
    }
}

public protocol TextTableProvider: class {
    func getTextTableText(forIdentifier identifier: Any) -> TextTableCellType
}

public protocol TextTableActions: class {
    func tapTextTable(forIdentifier identifier: Any)
}
