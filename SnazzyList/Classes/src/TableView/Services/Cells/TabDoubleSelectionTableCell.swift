//
//  TabDoubleSelectionTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 9/30/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a tab with 2 buttons.
/// The font, the titles and the colors can be customized.
final class TabDoubleSelectionTableCell: UITableViewCell {
    let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 40.0)
    let leftButton = UIButton(font: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .black, title: "", backgroundColor: .clear)
    let rightButton = UIButton(font: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .black, title: "", backgroundColor: .clear)
    let leftButtonView = UIView(backgroundColor: .white)
    let rightButtonView = UIView(backgroundColor: .white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapLeftButton() {
        configFile?.actions?.tapTabDoubleSelectionLeftButton(withIdentifier: configFile?.identifier)
        configureButtons()
    }
    
    @objc func tapRightButton() {
        configFile?.actions?.tapTabDoubleSelectionRightButton(withIdentifier: configFile?.identifier)
        configureButtons()
    }
    
    private var configFile: TabDoubleSelectionTableCellConfigFile?
}

extension TabDoubleSelectionTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? TabDoubleSelectionTableCellConfigFile else { return }
        self.configFile = configFile
        
        configureButtons()
    }
    
    private func configureButtons() {
        guard let configFile = self.configFile else { return }
        
        let leftButtonSelected = configFile.provider?.getTabDoubleSelectionLeftButtonIsSelected(forIdentifier: configFile.identifier) == true
        let rightButtonSelected = configFile.provider?.getTabDoubleSelectionRightButtonIsSelected(forIdentifier: configFile.identifier) == true
        
        leftButton.setTitle(configFile.leftTitle, for: .normal)
        leftButton.titleLabel?.font = leftButtonSelected ? configFile.buttonsSelectedFont : configFile.buttonsFont
        leftButton.setTitleColor(leftButtonSelected ? configFile.buttonsSelectedTitleColor : configFile.buttonsTitleColor, for: .normal)
        leftButtonView.backgroundColor = leftButtonSelected ? configFile.buttonsSelectedBackgroundColor : configFile.buttonsBackgroundColor
        
        rightButton.setTitle(configFile.rightTitle, for: .normal)
        rightButton.titleLabel?.font = rightButtonSelected ? configFile.buttonsSelectedFont : configFile.buttonsFont
        rightButton.setTitleColor(rightButtonSelected ? configFile.buttonsSelectedTitleColor : configFile.buttonsTitleColor, for: .normal)
        rightButtonView.backgroundColor = rightButtonSelected ? configFile.buttonsSelectedBackgroundColor : configFile.buttonsBackgroundColor
        
        stackView.spacing = configFile.spacingBetweenButtons
        
        layoutIfNeeded()
    }
}

extension TabDoubleSelectionTableCell {
    private func setupViews() {
        setupBackground()
        setupRightButtonView()
        setupLeftButtonView()
        setupStackView()
        setupLeftButton()
        setupRightButton()
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
    }
    
    private func setupRightButtonView() {
        rightButtonView.layer.cornerRadius = 12.0
        contentView.addSubview(rightButtonView)
    }
    
    private func setupLeftButtonView() {
        leftButtonView.layer.cornerRadius = 12.0
        contentView.addSubview(leftButtonView)
    }
    
    private func setupLeftButton() {
        leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        stackView.addArrangedSubview(leftButton)
    }
    
    private func setupRightButton() {
        rightButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
        stackView.addArrangedSubview(rightButton)
    }
    
    private func setupConstraints() {
        leftButton.assignSize(height: 24.0)
        rightButton.assignSize(height: 24.0)
        
        leftButtonView.matchEdges(to: leftButton, horizontalConstants: 16.0, verticalConstants: 0.0)
        rightButtonView.matchEdges(to: rightButton, horizontalConstants: 16.0, verticalConstants: 0.0)
        
        stackView.bind(withConstant: 4.0, boundType: .vertical)
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.bindFrameGreaterOrEqualToSuperviewBounds(withConstant: 4.0, boundType: .horizontal)
    }
}

struct TabDoubleSelectionTableCellConfigFile {
    let identifier: Any?
    let leftTitle: String
    let rightTitle: String
    let buttonsFont: UIFont
    let buttonsTitleColor: UIColor
    let buttonsBackgroundColor: UIColor
    let buttonsSelectedFont: UIFont
    let buttonsSelectedTitleColor: UIColor
    let buttonsSelectedBackgroundColor: UIColor
    let spacingBetweenButtons: CGFloat
    
    weak var provider: TabDoubleSelectionTableCellProvider?
    weak var actions: TabDoubleSelectionTableCellActions?
    
    init(identifier: Any?, leftTitle: String, rightTitle: String, buttonsFont: UIFont, buttonsTitleColor: UIColor, buttonsBackgroundColor: UIColor, buttonsSelectedFont: UIFont, buttonsSelectedTitleColor: UIColor, buttonsSelectedBackgroundColor: UIColor, spacingBetweenButtons: CGFloat, provider: TabDoubleSelectionTableCellProvider?, actions: TabDoubleSelectionTableCellActions?) {
        self.identifier = identifier
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.buttonsFont = buttonsFont
        self.buttonsTitleColor = buttonsTitleColor
        self.buttonsBackgroundColor = buttonsBackgroundColor
        self.buttonsSelectedFont = buttonsSelectedFont
        self.buttonsSelectedTitleColor = buttonsSelectedTitleColor
        self.buttonsSelectedBackgroundColor = buttonsSelectedBackgroundColor
        self.spacingBetweenButtons = spacingBetweenButtons
        self.provider = provider
        self.actions = actions
    }
}

public protocol TabDoubleSelectionTableCellProvider: class {
    func getTabDoubleSelectionLeftButtonIsSelected(forIdentifier identifier: Any?) -> Bool?
    func getTabDoubleSelectionRightButtonIsSelected(forIdentifier identifier: Any?) -> Bool?
}

public protocol TabDoubleSelectionTableCellActions: class {
    func tapTabDoubleSelectionLeftButton(withIdentifier identifier: Any?)
    func tapTabDoubleSelectionRightButton(withIdentifier identifier: Any?)
}
