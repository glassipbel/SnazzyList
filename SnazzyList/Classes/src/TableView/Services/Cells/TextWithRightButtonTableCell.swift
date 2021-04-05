//
//  TextWithRightButtonTableCell.swift
//  Noteworth2
//
//  Created by Olga Matsyk on 12/16/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

import UIKit

final class TextWithRightButtonTableCell: UITableViewCell {
    private let titleLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .medium), textColor: .black, textAlignment: .left)
    private let rightButton = UIButton(font: .systemFont(ofSize: 12.0, weight: .medium), titleColor: .white, title: "", backgroundColor: .blue)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
           
        setupViews()
        setupConstraints()
    }
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapRightButton() {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.tapTextWithRightButtonActionButton(withIdentifier: configFile.identifier)
    }
       
    private var configFile: TextWithRightButtonTableCellConfigFile?
}

extension TextWithRightButtonTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
           guard let configFile = item as? TextWithRightButtonTableCellConfigFile else { return }
        self.configFile = configFile
        
        titleLabel.text = configFile.provider?.getTextWithRightButtonTitle(withIdentifier: configFile.identifier) ?? configFile.text
        titleLabel.textColor = configFile.textColor
        titleLabel.font = configFile.textFont
        
        rightButton.setTitle(configFile.buttonTitle, for: .normal)
        rightButton.backgroundColor = configFile.buttonBackgroundColor
        rightButton.layer.cornerRadius = configFile.buttonShouldHaveRoundedBorders == true ? 12.0 : 0.0
        rightButton.setTitleColor(configFile.buttonTextColor, for: .normal)
        rightButton.isHidden = configFile.actions == nil
        
        if configFile.backgroundColor == configFile.buttonBackgroundColor {
            rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        } else {
            rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
        }
        
        contentView.backgroundColor = configFile.backgroundColor
    }
}

private extension TextWithRightButtonTableCell {
    private func setupViews() {
        setupBackground(backgroundColor: .white)
        setupTitleLabel()
        setupRightButton()
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupRightButton() {
        rightButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
        contentView.addSubview(rightButton)
    }
    
    private func setupConstraints() {
        titleLabel.centerYAnchor.constraint(equalTo: rightButton.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: 8.0).isActive = true
        
        rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        rightButton.bind(withConstant: 0.0, boundType: .vertical)
        rightButton.assignSize(height: 24.0)
        rightButton.setContentHuggingPriority(.max, for: .horizontal)
        rightButton.setContentCompressionResistancePriority(.max, for: .horizontal)
    }
}

struct TextWithRightButtonTableCellConfigFile {
    let identifier: Any?
    let text: String
    let textColor: UIColor
    let textFont: UIFont
    let buttonTitle: String
    let buttonTextColor: UIColor
    let buttonBackgroundColor: UIColor
    let buttonShouldHaveRoundedBorders: Bool
    let backgroundColor: UIColor
    
    weak var provider: TextWithRightButtonTableCellProvider?
    weak var actions: TextWithRightButtonTableCellActions?
    
    init(identifier: Any?, text: String, textColor: UIColor, textFont: UIFont, buttonTitle: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, buttonShouldHaveRoundedBorders: Bool, backgroundColor: UIColor, actions: TextWithRightButtonTableCellActions?, provider: TextWithRightButtonTableCellProvider?) {
        self.identifier = identifier
        self.text = text
        self.textColor = textColor
        self.textFont = textFont
        self.buttonTitle = buttonTitle
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonShouldHaveRoundedBorders = buttonShouldHaveRoundedBorders
        self.backgroundColor = backgroundColor
        
        self.actions = actions
        self.provider = provider
    }
}

public protocol TextWithRightButtonTableCellProvider: class {
    func getTextWithRightButtonTitle(withIdentifier identifier: Any?) -> String?
}

public protocol TextWithRightButtonTableCellActions: class {
    func tapTextWithRightButtonActionButton(withIdentifier identifier: Any?)
}
