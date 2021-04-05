//
//  TitleWithValueTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 2/19/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

import UIKit

/// This cell will fit the cases were you need to show a cell with a title and value, title aligned to the left and the value to the right.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TitleWithValueTableCell.png?raw=true
final class TitleWithValueTableCell: UITableViewCell {
    private let titleLabel = UILabel(font: .systemFont(ofSize: 6.0, weight: .regular), textColor: .black, textAlignment: .left)
    private let valueLabel = UILabel(font: .systemFont(ofSize: 6.0, weight: .medium), textColor: .black, textAlignment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleWithValueTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? TitleWithValueTableCellConfigFile else { return }
        
        titleLabel.text = configFile.title
        titleLabel.font = configFile.titleFont
        titleLabel.textColor = configFile.titleColor
        valueLabel.text = configFile.value
        valueLabel.font = configFile.valueFont
        valueLabel.textColor = configFile.valueColor
    }
}

private extension TitleWithValueTableCell {
    private func setupViews() {
        setupBackground()
        setupTitleLabel()
        setupValueLabel()
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupValueLabel() {
        contentView.addSubview(valueLabel)
    }
    
    private func setupConstraints() {
        titleLabel.bind(withConstant: 16.0, boundType: .vertical)
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -8.0).isActive = true
        
        valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        valueLabel.setContentHuggingPriority(.max, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.max, for: .horizontal)
    }
}

struct TitleWithValueTableCellConfigFile {
    let title: String
    let titleFont: UIFont
    let titleColor: UIColor
    let value: String
    let valueFont: UIFont
    let valueColor: UIColor
    
    init(title: String, titleFont: UIFont, titleColor: UIColor, value: String, valueFont: UIFont, valueColor: UIColor) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.value = value
        self.valueFont = valueFont
        self.valueColor = valueColor
    }
}
