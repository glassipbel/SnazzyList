//
//  ComplexDoubleButtonTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 9/2/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a button that it can be enable and disable dynamically depending on the context of your view. If that's the case then this will be a good fit, if the button will always be enabled, then you should take a look at BasicButtonTableCell.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/ComplexButtonTableCell.png?raw=true
final class ComplexDoubleButtonTableCell: UITableViewCell {
    let leftButton = UIButton(font: .systemFont(ofSize: 16.0, weight: .bold), titleColor: .white, title: "", backgroundColor: .blue)
    let rightButton = UIButton(font: .systemFont(ofSize: 16.0, weight: .bold), titleColor: .white, title: "", backgroundColor: .blue)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: ComplexDoubleButtonTableCellConfigFile?
}

extension ComplexDoubleButtonTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? ComplexDoubleButtonTableCellConfigFile else { return }

        if let previousConfigFile = self.configFile {
            leftButton.removeTarget(previousConfigFile.leftTarget, action: previousConfigFile.leftSelector, for: .touchUpInside)
            rightButton.removeTarget(previousConfigFile.rightTarget, action: previousConfigFile.rightSelector, for: .touchUpInside)
        }
        
        self.configFile = configFile
        
        let leftButtonIsEnabled = configFile.provider?.getLeftComplexButtonIsEnabled(forIdentifier: configFile.identifier) == true
        let rightButtonIsEnabled = configFile.provider?.getRightComplexButtonIsEnabled(forIdentifier: configFile.identifier) == true
        
        leftButton.addTarget(configFile.leftTarget, action: configFile.leftSelector, for: .touchUpInside)
        leftButton.setTitle(configFile.leftTitle, for: .normal)
        leftButton.titleLabel?.font = configFile.leftFont
        leftButton.setTitleColor(leftButtonIsEnabled ? configFile.leftTextColor : configFile.leftTextColorDisabled, for: .normal)
        leftButton.backgroundColor = leftButtonIsEnabled ? configFile.leftBackgroundColor : configFile.leftBackgroundColorDisabled
        leftButton.isEnabled = leftButtonIsEnabled
        
        rightButton.addTarget(configFile.rightTarget, action: configFile.rightSelector, for: .touchUpInside)
        rightButton.setTitle(configFile.rightTitle, for: .normal)
        rightButton.titleLabel?.font = configFile.rightFont
        rightButton.setTitleColor(rightButtonIsEnabled ? configFile.rightTextColor : configFile.rightTextColorDisabled, for: .normal)
        rightButton.backgroundColor = rightButtonIsEnabled ? configFile.rightBackgroundColor : configFile.rightBackgroundColorDisabled
        rightButton.isEnabled = rightButtonIsEnabled
    }
}

private extension ComplexDoubleButtonTableCell {
    private func setupViews() {
        setupBackground()
        leftButton.layer.cornerRadius = 4.0
        rightButton.layer.cornerRadius = 4.0
        self.contentView.addSubview(leftButton)
        self.contentView.addSubview(rightButton)
    }
    
    private func setupConstraints() {
        leftButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0).isActive = true
        leftButton.bind(withConstant: 8.0, boundType: .vertical)
        leftButton.assignSize(height: 64.0)
        leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor).isActive = true
        
        rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8.0).isActive = true
        rightButton.bind(withConstant: 8.0, boundType: .vertical)
        rightButton.assignSize(height: 64.0)
    }
}

struct ComplexDoubleButtonTableCellConfigFile {
    let identifier: Any?
    let leftTitle: String
    let leftFont: UIFont
    let leftBackgroundColor: UIColor
    let leftTextColor: UIColor
    let leftBackgroundColorDisabled: UIColor
    let leftTextColorDisabled: UIColor
    let leftSelector: Selector
    let leftTarget: Any?
    let rightTitle: String
    let rightFont: UIFont
    let rightBackgroundColor: UIColor
    let rightTextColor: UIColor
    let rightBackgroundColorDisabled: UIColor
    let rightTextColorDisabled: UIColor
    let rightSelector: Selector
    let rightTarget: Any?
    
    weak var provider: ComplexDoubleButtonTableCellProvider?
    
    init(identifier: Any?, leftTitle: String, leftFont: UIFont, leftBackgroundColor: UIColor, leftTextColor: UIColor, leftBackgroundColorDisabled: UIColor, leftTextColorDisabled: UIColor, leftSelector: Selector, leftTarget: Any?, rightTitle: String, rightFont: UIFont, rightBackgroundColor: UIColor, rightTextColor: UIColor, rightBackgroundColorDisabled: UIColor, rightTextColorDisabled: UIColor, rightSelector: Selector, rightTarget: Any?, provider: ComplexDoubleButtonTableCellProvider?) {
        self.identifier = identifier
        self.leftTitle = leftTitle
        self.leftFont = leftFont
        self.leftBackgroundColor = leftBackgroundColor
        self.leftBackgroundColorDisabled = leftBackgroundColorDisabled
        self.leftTextColorDisabled = leftTextColorDisabled
        self.leftTextColor = leftTextColor
        self.leftSelector = leftSelector
        self.leftTarget = leftTarget
        self.rightTitle = rightTitle
        self.rightFont = rightFont
        self.rightBackgroundColor = rightBackgroundColor
        self.rightBackgroundColorDisabled = rightBackgroundColorDisabled
        self.rightTextColorDisabled = rightTextColorDisabled
        self.rightTextColor = rightTextColor
        self.rightSelector = rightSelector
        self.rightTarget = rightTarget
        self.provider = provider
    }
}

public protocol ComplexDoubleButtonTableCellProvider: class {
    func getLeftComplexButtonIsEnabled(forIdentifier identifier: Any?) -> Bool
    func getRightComplexButtonIsEnabled(forIdentifier identifier: Any?) -> Bool
}
