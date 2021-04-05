//
//  BasicButtonTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 3/7/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a button that it can be enable and disable dynamically depending on the context of your view. If that's the case then this will be a good fit, if the button will always be enabled, then you should take a look at BasicButtonTableCell.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/ComplexButtonTableCell.png?raw=true
final class ComplexButtonTableCell: UITableViewCell {
    let mainButton = UIButton(font: .systemFont(ofSize: 16.0, weight: .bold), titleColor: .white, title: "", backgroundColor: .blue)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: ComplexButtonTableCellConfigFile?
}

extension ComplexButtonTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? ComplexButtonTableCellConfigFile else { return }
        if let previousConfigFile = self.configFile {
            mainButton.removeTarget(previousConfigFile.target, action: previousConfigFile.selector, for: .touchUpInside)
        }
        self.configFile = configFile
        let isEnabled = configFile.provider?.getComplexButtonIsEnabled(forIdentifier: configFile.identifier) == true
        
        mainButton.addTarget(configFile.target, action: configFile.selector, for: .touchUpInside)
        mainButton.setTitle(configFile.title, for: .normal)
        mainButton.titleLabel?.font = configFile.font
        mainButton.setTitleColor(isEnabled ? configFile.textColor : configFile.textColorDisabled, for: .normal)
        mainButton.backgroundColor = isEnabled ? configFile.backgroundColor : configFile.backgroundColorDisabled
        mainButton.isEnabled = isEnabled
    }
}

private extension ComplexButtonTableCell {
    private func setupViews() {
        setupBackground()
        mainButton.layer.cornerRadius = 4.0
        self.contentView.addSubview(mainButton)
    }
    
    private func setupConstraints() {
        mainButton.bind(withConstant: 8.0, boundType: .full)
        mainButton.assignSize(height: 64.0)
    }
}

struct ComplexButtonTableCellConfigFile {
    let identifier: Any?
    let title: String
    let font: UIFont
    let backgroundColor: UIColor
    let textColor: UIColor
    let backgroundColorDisabled: UIColor
    let textColorDisabled: UIColor
    let selector: Selector
    let target: Any?
    
    weak var provider: ComplexButtonTableCellProvider?
    
    init(identifier: Any?, title: String, font: UIFont, backgroundColor: UIColor, textColor: UIColor, backgroundColorDisabled: UIColor, textColorDisabled: UIColor, selector: Selector, target: Any?, provider: ComplexButtonTableCellProvider?) {
        self.title = title
        self.font = font
        self.identifier = identifier
        self.backgroundColor = backgroundColor
        self.backgroundColorDisabled = backgroundColorDisabled
        self.textColorDisabled = textColorDisabled
        self.textColor = textColor
        self.selector = selector
        self.target = target
        self.provider = provider
    }
}

public protocol ComplexButtonTableCellProvider: class {
    func getComplexButtonIsEnabled(forIdentifier identifier: Any?) -> Bool
}
