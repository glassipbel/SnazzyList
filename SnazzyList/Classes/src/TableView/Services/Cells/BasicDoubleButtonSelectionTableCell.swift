//
//  BasicDoubleButtonSelectionTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 9/30/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show 2 buttons for selection..
/// The font, the titles and the colors can be customized.
final class BasicDoubleButtonSelectionTableCell: UITableViewCell {
    let leftButton = UIButton(font: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .black, title: "", backgroundColor: .clear)
    let rightButton = UIButton(font: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .black, title: "", backgroundColor: .clear)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapLeftButton() {
        configFile?.actions?.tapBasicDoubleButtonSelectionLeftButton(withIdentifier: configFile?.identifier)
        configureButtons()
    }
    
    @objc func tapRightButton() {
        configFile?.actions?.tapBasicDoubleButtonSelectionRightButton(withIdentifier: configFile?.identifier)
        configureButtons()
    }
    
    private var configFile: BasicDoubleButtonSelectionTableCellConfigFile?
}

extension BasicDoubleButtonSelectionTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BasicDoubleButtonSelectionTableCellConfigFile else { return }
        
        self.configFile = configFile
        
        configureButtons()
    }
    
    private func configureButtons() {
        guard let configFile = self.configFile else { return }
        
        let leftButtonSelected = configFile.provider?.getBasicDoubleButtonSelectionLeftButtonIsSelected(forIdentifier: configFile.identifier) == true
        let rightButtonSelected = configFile.provider?.getBasicDoubleButtonSelectionRightButtonIsSelected(forIdentifier: configFile.identifier) == true
        
        leftButton.setTitle(configFile.leftTitle, for: .normal)
        leftButton.titleLabel?.font = leftButtonSelected ? configFile.buttonsSelectedFont : configFile.buttonsFont
        leftButton.setTitleColor(leftButtonSelected ? configFile.buttonsSelectedTitleColor : configFile.buttonsTitleColor, for: .normal)
        leftButton.backgroundColor = leftButtonSelected ? configFile.buttonsSelectedBackgroundColor : configFile.buttonsBackgroundColor
        
        rightButton.setTitle(configFile.rightTitle, for: .normal)
        rightButton.titleLabel?.font = rightButtonSelected ? configFile.buttonsSelectedFont : configFile.buttonsFont
        rightButton.setTitleColor(rightButtonSelected ? configFile.buttonsSelectedTitleColor : configFile.buttonsTitleColor, for: .normal)
        rightButton.backgroundColor = rightButtonSelected ? configFile.buttonsSelectedBackgroundColor : configFile.buttonsBackgroundColor
    }
}

extension BasicDoubleButtonSelectionTableCell {
    private func setupViews() {
        setupBackground()
        setupLeftButton()
        setupRightButton()
    }
    
    private func setupLeftButton() {
        leftButton.layer.cornerRadius = 4.0
        leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        contentView.addSubview(leftButton)
    }
    
    private func setupRightButton() {
        rightButton.layer.cornerRadius = 4.0
        rightButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
        contentView.addSubview(rightButton)
    }
    
    private func setupConstraints() {
        leftButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        leftButton.bind(withConstant: 0.0, boundType: .vertical)
        
        rightButton.leftAnchor.constraint(equalTo: leftButton.rightAnchor, constant: 8.0).isActive = true
        rightButton.bind(withConstant: 0.0, boundType: .vertical)
        rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor).isActive = true
    }
}

struct BasicDoubleButtonSelectionTableCellConfigFile {
    let identifier: Any?
    let leftTitle: String
    let rightTitle: String
    let buttonsFont: UIFont
    let buttonsTitleColor: UIColor
    let buttonsBackgroundColor: UIColor
    let buttonsSelectedFont: UIFont
    let buttonsSelectedTitleColor: UIColor
    let buttonsSelectedBackgroundColor: UIColor
    
    weak var provider: BasicDoubleButtonSelectionTableCellProvider?
    weak var actions: BasicDoubleButtonSelectionTableCellActions?
    
    init(identifier: Any?, leftTitle: String, rightTitle: String, buttonsFont: UIFont, buttonsTitleColor: UIColor, buttonsBackgroundColor: UIColor, buttonsSelectedFont: UIFont, buttonsSelectedTitleColor: UIColor, buttonsSelectedBackgroundColor: UIColor, provider: BasicDoubleButtonSelectionTableCellProvider?, actions: BasicDoubleButtonSelectionTableCellActions?) {
        self.identifier = identifier
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.buttonsFont = buttonsFont
        self.buttonsTitleColor = buttonsTitleColor
        self.buttonsBackgroundColor = buttonsBackgroundColor
        self.buttonsSelectedFont = buttonsSelectedFont
        self.buttonsSelectedTitleColor = buttonsSelectedTitleColor
        self.buttonsSelectedBackgroundColor = buttonsSelectedBackgroundColor
        self.provider = provider
        self.actions = actions
    }
}

public protocol BasicDoubleButtonSelectionTableCellProvider: class {
    func getBasicDoubleButtonSelectionLeftButtonIsSelected(forIdentifier identifier: Any?) -> Bool?
    func getBasicDoubleButtonSelectionRightButtonIsSelected(forIdentifier identifier: Any?) -> Bool?
}

public protocol BasicDoubleButtonSelectionTableCellActions: class {
    func tapBasicDoubleButtonSelectionLeftButton(withIdentifier identifier: Any?)
    func tapBasicDoubleButtonSelectionRightButton(withIdentifier identifier: Any?)
}
