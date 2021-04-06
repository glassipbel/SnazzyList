//
//  ReadingTextInputTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 9/2/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to enter numeric values for the readings.
final class ReadingNumericInputTableCell: UITableViewCell {
    private let iconImageView = UIImageView(image: nil, contentMode: .scaleAspectFit)
    private let nameLabel = UILabel(font: .systemFont(ofSize: 15.0, weight: .regular), textColor: .black, textAlignment: .left)
    private let inputValueLabel = UILabel(font: .systemFont(ofSize: 24.0, weight: .medium), textColor: .black, textAlignment: .center)
    private let minusButton = UIButton(image: UIImage(named: "minus_medium", in: Bundle.resourceBundle(for: ReadingNumericInputTableCell.self), compatibleWith: nil)!, contentMode: .scaleAspectFit)
    private let plusButton = UIButton(image: UIImage(named: "plus_medium", in: Bundle.resourceBundle(for: ReadingNumericInputTableCell.self), compatibleWith: nil)!, contentMode: .scaleAspectFit)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapMinus() {
        guard let configFile = self.configFile else { return }
        configFile.actions?.onTapReadingNumericInputMinus(forIdentifier: configFile.identifier)
        let value = configFile.provider?.getReadingNumericInputValue(forIdentifier: configFile.identifier) ?? 0
        inputValueLabel.text = "\(value)"
    }
    
    @objc func tapPlus() {
        guard let configFile = self.configFile else { return }
        configFile.actions?.onTapReadingNumericInputPlus(forIdentifier: configFile.identifier)
        let value = configFile.provider?.getReadingNumericInputValue(forIdentifier: configFile.identifier) ?? 0
        inputValueLabel.text = "\(value)"
    }
    
    private var configFile: ReadingNumericInputTableCellConfigFile?
}

extension ReadingNumericInputTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? ReadingNumericInputTableCellConfigFile else { return }
        self.configFile = configFile
        
        contentView.backgroundColor = configFile.backgroundColor
        iconImageView.image = configFile.icon
        nameLabel.text = configFile.name
        nameLabel.font = configFile.nameFont
        nameLabel.textColor = configFile.textColor
        let value = configFile.provider?.getReadingNumericInputValue(forIdentifier: configFile.identifier) ?? 0
        inputValueLabel.text = "\(value)"
        inputValueLabel.font = configFile.inputFont
        inputValueLabel.textColor = configFile.textColor
    }
}

private extension ReadingNumericInputTableCell {
    private func setupViews() {
        setupBackground(backgroundColor: .lightGray)
        setupIconImageView()
        setupNameLabel()
        setupInputValueLabel()
        setupMinusButton()
        setupPlusButton()
    }
    
    private func setupIconImageView() {
        contentView.addSubview(iconImageView)
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
    }
    
    private func setupInputValueLabel() {
        contentView.addSubview(inputValueLabel)
    }
    
    private func setupPlusButton() {
        plusButton.addTarget(self, action: #selector(tapPlus), for: .touchUpInside)
        contentView.addSubview(plusButton)
    }
    
    private func setupMinusButton() {
        minusButton.addTarget(self, action: #selector(tapMinus), for: .touchUpInside)
        contentView.addSubview(minusButton)
    }
    
    private func setupConstraints() {
        iconImageView.bind(withConstant: 2.0, boundType: .vertical)
        iconImageView.assignSize(width: 32, height: 32)
        iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8.0).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: minusButton.leftAnchor, constant: -4.0).isActive = true
        
        minusButton.rightAnchor.constraint(equalTo: inputValueLabel.leftAnchor, constant: -4.0).isActive = true
        minusButton.assignSize(width: 25.0, height: 25.0)
        minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        inputValueLabel.rightAnchor.constraint(equalTo: plusButton.leftAnchor, constant: -4.0).isActive = true
        inputValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        inputValueLabel.assignSize(width: 40.0)
            
        plusButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        plusButton.assignSize(width: 25.0, height: 25.0)
        plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

struct ReadingNumericInputTableCellConfigFile {
    let identifier: Any
    let icon: UIImage
    let name: String
    let backgroundColor: UIColor
    let textColor: UIColor
    let nameFont: UIFont
    let inputFont: UIFont
    
    weak var provider: ReadingNumericInputTableCellProvider?
    weak var actions: ReadingNumericInputTableCellActions?
    
    init(identifier: Any, icon: UIImage, name: String, backgroundColor: UIColor, textColor: UIColor, nameFont: UIFont, inputFont: UIFont, provider: ReadingNumericInputTableCellProvider?, actions: ReadingNumericInputTableCellActions?) {
        self.identifier = identifier
        self.icon = icon
        self.name = name
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.nameFont = nameFont
        self.inputFont = inputFont
        
        self.provider = provider
        self.actions = actions
    }
}

public protocol ReadingNumericInputTableCellProvider: class {
    func getReadingNumericInputValue(forIdentifier identifier: Any) -> Int?
}

public protocol ReadingNumericInputTableCellActions: class {
    func onTapReadingNumericInputPlus(forIdentifier identifier: Any)
    func onTapReadingNumericInputMinus(forIdentifier identifier: Any)
}
