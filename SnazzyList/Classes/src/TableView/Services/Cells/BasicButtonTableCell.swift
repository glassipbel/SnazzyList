//
//  BasicButtonTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 3/7/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

import UIKit

/// This cell will fit the cases were you need to show a button that it will always be enabled. If that's the case then this will be a good fit, if the button can be dynamically change from enable to disable depending on the context, then you should take a look at ComplexButtonTableCell.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicButtonTableCell.png?raw=true
public final class BasicButtonTableCell: UITableViewCell {
    public let mainButton = UIButton(font: .systemFont(ofSize: 16.0, weight: .bold), titleColor: .white, title: "", backgroundColor: .blue)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: BasicButtonTableCellConfigFile?
    private var leftButtonConstraint: NSLayoutConstraint?
    private var rightButtonConstraint: NSLayoutConstraint?
    private var heightButtonConstraint: NSLayoutConstraint?
}

extension BasicButtonTableCell: GenericTableCellProtocol {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BasicButtonTableCellConfigFile else { return }
        
        if let previousConfigFile = self.configFile {
            mainButton.removeTarget(previousConfigFile.target, action: previousConfigFile.selector, for: .touchUpInside)
        }
        
        self.configFile = configFile
        
        mainButton.addTarget(configFile.target, action: configFile.selector, for: .touchUpInside)
        mainButton.setTitle(configFile.title, for: .normal)
        mainButton.setTitleColor(configFile.textColor, for: .normal)
        mainButton.backgroundColor = configFile.backgroundColor
        mainButton.titleLabel?.font = configFile.font
        leftButtonConstraint?.constant = configFile.leftMargin
        rightButtonConstraint?.constant = configFile.rightMargin
        heightButtonConstraint?.constant = configFile.buttonHeight
        
        if configFile.underline {
            let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: configFile.font,
            .foregroundColor: configFile.textColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            let attributedString = NSMutableAttributedString(string: configFile.title,
            attributes: yourAttributes)
            
            mainButton.setAttributedTitle(attributedString, for: .normal)
        } else {
            mainButton.setAttributedTitle(nil, for: .normal)
        }
        
        contentView.layoutIfNeeded()
    }
}

private extension BasicButtonTableCell {
    private func setupViews() {
        setupBackground()
        mainButton.layer.cornerRadius = 4.0
        self.contentView.addSubview(mainButton)
    }
    
    private func setupConstraints() {
        mainButton.bind(withConstant: 8.0, boundType: .vertical)
        leftButtonConstraint = mainButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0)
        leftButtonConstraint?.isActive = true
        rightButtonConstraint = contentView.rightAnchor.constraint(equalTo: mainButton.rightAnchor, constant: 8.0)
        rightButtonConstraint?.isActive = true
        heightButtonConstraint = mainButton.heightAnchor.constraint(equalToConstant: 64.0)
        heightButtonConstraint?.isActive = true
    }
}

struct BasicButtonTableCellConfigFile {
    let title: String
    let backgroundColor: UIColor
    let textColor: UIColor
    let selector: Selector
    let target: Any?
    let underline: Bool
    let font: UIFont
    let leftMargin: CGFloat
    let rightMargin: CGFloat
    let buttonHeight: CGFloat
    
    init(title: String, backgroundColor: UIColor, textColor: UIColor, selector: Selector, target: Any?, underline: Bool, font: UIFont, leftMargin: CGFloat, rightMargin: CGFloat, buttonHeight: CGFloat) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.selector = selector
        self.target = target
        self.underline = underline
        self.font = font
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.buttonHeight = buttonHeight
    }
}
