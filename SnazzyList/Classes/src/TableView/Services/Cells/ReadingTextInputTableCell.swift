//
//  ReadingTextInputTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 9/2/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to enter values for the readings using a textfield as an input.
final class ReadingTextInputTableCell: UITableViewCell {
    private let iconImageView = UIImageView(image: nil, contentMode: .scaleAspectFit)
    private let nameLabel = UILabel(font: .systemFont(ofSize: 15.0, weight: .regular), textColor: .black, textAlignment: .left)
    private let inputValueTextField = UITextField(placeholderText: nil, font: .systemFont(ofSize: 24.0, weight: .medium), textColor: .black, backgroundColor: .lightGray, borderStyle: .line, borderColor: .blue, placeholderTextColor: .gray, placeholderFont: nil, paddingLeft: 6.0, paddingRight: 6.0)
    private let inputValueNameLabel = UILabel(font: .systemFont(ofSize: 15.0, weight: .regular), textColor: .black, textAlignment: .left)
    private let inputValueLabel = UILabel(font: .systemFont(ofSize: 24.0, weight: .medium), textColor: .black, textAlignment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var inputValueNameLabelWidthConstraint: NSLayoutConstraint?
    private var inputTextfieldWidthConstraint: NSLayoutConstraint?
    private var configFile: ReadingTextInputTableCellConfigFile?
}

extension ReadingTextInputTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? ReadingTextInputTableCellConfigFile else { return }
        self.configFile = configFile
        
        contentView.backgroundColor = configFile.backgroundColor
        iconImageView.image = configFile.icon
        nameLabel.text = configFile.name
        nameLabel.font = configFile.nameFont
        nameLabel.textColor = configFile.nameColor
        inputValueTextField.isHidden = configFile.isReadOnly
        inputValueLabel.isHidden = !configFile.isReadOnly
        
        inputValueTextField.text = configFile.provider?.getReadingTextInputValue(forIdentifier: configFile.identifier)
        inputValueTextField.font = configFile.valueTextFont
        inputValueTextField.backgroundColor = configFile.backgroundColor
        inputValueTextField.layer.borderWidth = 1.0
        inputValueTextField.layer.borderColor = configFile.valueTextBorderColor.cgColor
        inputValueTextField.keyboardType = configFile.allowDecimal ? .decimalPad : .numberPad
        inputTextfieldWidthConstraint?.constant = configFile.inputTextfieldWidth
        inputValueTextField.isEnabled = configFile.isEditable
        inputValueTextField.textColor = configFile.isEditable ? configFile.valueTextEditableColor : configFile.valueTextNotEditableColor
        
        inputValueLabel.text = configFile.provider?.getReadingTextInputValue(forIdentifier: configFile.identifier)
        inputValueLabel.textColor = configFile.valueColor
        inputValueLabel.font = configFile.valueFont
        
        inputValueNameLabel.text = configFile.valueName
        inputValueNameLabel.textColor = configFile.valueNameColor
        inputValueNameLabel.font = configFile.valueNameFont
        
        if let constant = configFile.valueNameWidth {
            inputValueNameLabelWidthConstraint?.constant = constant
            inputValueNameLabelWidthConstraint?.isActive = true
        } else {
            inputValueNameLabelWidthConstraint?.isActive = false
        }
        
        contentView.layoutIfNeeded()
    }
}

private extension ReadingTextInputTableCell {
    private func setupViews() {
        setupBackground(backgroundColor: .lightGray)
        setupIconImageView()
        setupNameLabel()
        setupInputValueTextField()
        setupInputValueNameLabel()
        setupInputValueLabel()
    }
    
    private func setupIconImageView() {
        contentView.addSubview(iconImageView)
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
    }
    
    private func setupInputValueTextField() {
        inputValueTextField.delegate = self
        inputValueTextField.keyboardType = .decimalPad
        inputValueTextField.layer.cornerRadius = 3.0
        inputValueTextField.textAlignment = .right
        contentView.addSubview(inputValueTextField)
    }
    
    private func setupInputValueNameLabel() {
        contentView.addSubview(inputValueNameLabel)
    }
    
    private func setupInputValueLabel() {
        contentView.addSubview(inputValueLabel)
    }
    
    private func setupConstraints() {
        iconImageView.bind(withConstant: 2.0, boundType: .vertical)
        iconImageView.assignSize(width: 32, height: 32)
        iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8.0).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: inputValueTextField.leftAnchor, constant: -4.0).isActive = true
        
        inputValueNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        inputValueNameLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1.0).isActive = true
        
        inputValueTextField.rightAnchor.constraint(equalTo: inputValueNameLabel.leftAnchor, constant: -8.0).isActive = true
        inputValueTextField.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        inputValueTextField.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor).isActive = true
        inputTextfieldWidthConstraint = inputValueTextField.widthAnchor.constraint(equalToConstant: 86.0)
        inputTextfieldWidthConstraint?.isActive = true
        
        inputValueLabel.rightAnchor.constraint(equalTo: inputValueNameLabel.leftAnchor, constant: -3.0).isActive = true
        inputValueLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor).isActive = true
        
        inputValueNameLabelWidthConstraint = inputValueNameLabel.widthAnchor.constraint(equalToConstant: 35.0)
    }
}

extension ReadingTextInputTableCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputValueTextField.layer.borderColor = configFile?.valueTextEditableColor.cgColor ?? UIColor.clear.cgColor
        inputValueTextField.layer.borderWidth = 2.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        inputValueTextField.layer.borderColor = configFile?.valueTextNotEditableColor.cgColor ?? UIColor.clear.cgColor
        inputValueTextField.layer.borderWidth = 1.0
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let configFile = self.configFile else { return true }
        let isValid = configFile.provider?.getReadingTextInputShouldEndEditing(forIdentifier: configFile.identifier) == true
        if isValid { return true }
        inputValueTextField.shakeWithColor()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let configFile = self.configFile else { return false }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        let value = String(newString) == "" ? nil : String(newString)
        let maxValue = configFile.maxValue ?? Double.greatestFiniteMagnitude
        if newString.length > (configFile.allowDecimal ? (maxValue >= 10000 ? 7 : maxValue >= 1000 ? 6 : maxValue >= 100 ? 5 : 4) : 3) { return false }
        
        guard let valueString = value else {
            configFile.actions?.onReadingTextInputValueChanged(forIdentifier: configFile.identifier, value: value)
            return true
        }
        
        let doubleValue: Double
        if configFile.allowDecimal {
            guard let valueTransformed = Double(valueString) else {
                return false
            }
            doubleValue = valueTransformed
        } else {
            guard let valueTransformed = Int(valueString) else {
                return false
            }
            doubleValue = Double(valueTransformed)
        }
        
        if let maxValue = configFile.maxValue {
            if doubleValue > maxValue { return false }
        }
        
        if configFile.allowDecimal {
            if let valueGroups = value?.components(separatedBy: ".") {
                if valueGroups.count > 2 { return false }
                if valueGroups.count == 2 {
                    if valueGroups[1].count > 1 { return false }
                }
            }
        }
        
        configFile.actions?.onReadingTextInputValueChanged(forIdentifier: configFile.identifier, value: value)
        return true
    }
}

struct ReadingTextInputTableCellConfigFile {
    let identifier: Any
    let icon: UIImage
    let name: String
    let nameColor: UIColor
    let nameFont: UIFont
    let isReadOnly: Bool
    let backgroundColor: UIColor
    let valueColor: UIColor
    let valueFont: UIFont
    let valueName: String
    let valueNameWidth: CGFloat?
    let valueNameFont: UIFont
    let valueNameColor: UIColor
    let valueTextFont: UIFont
    let valueTextEditableColor: UIColor
    let valueTextNotEditableColor: UIColor
    let valueTextBackgroundColor: UIColor
    let valueTextBorderColor: UIColor
    let maxValue: Double?
    let minValue: Double?
    let allowDecimal: Bool
    let inputTextfieldWidth: CGFloat
    let isEditable: Bool
    
    weak var provider: ReadingTextInputTableCellProvider?
    weak var actions: ReadingTextInputTableCellActions?
    
    init(identifier: Any, icon: UIImage, name: String, nameColor: UIColor, nameFont: UIFont, isReadOnly: Bool, backgroundColor: UIColor, valueColor: UIColor, valueFont: UIFont, valueName: String, valueNameWidth: CGFloat?, valueNameFont: UIFont, valueNameColor: UIColor, valueTextFont: UIFont, valueTextEditableColor: UIColor, valueTextNotEditableColor: UIColor, valueTextBackgroundColor: UIColor, valueTextBorderColor: UIColor, minValue: Double?, maxValue: Double?, allowDecimal: Bool, inputTextfieldWidth: CGFloat, isEditable: Bool, provider: ReadingTextInputTableCellProvider?, actions: ReadingTextInputTableCellActions?) {
        self.identifier = identifier
        self.icon = icon
        self.name = name
        self.nameColor = nameColor
        self.nameFont = nameFont
        self.isReadOnly = isReadOnly
        self.backgroundColor = backgroundColor
        self.valueColor = valueColor
        self.valueFont = valueFont
        self.valueName = valueName
        self.valueNameWidth = valueNameWidth
        self.valueNameFont = valueNameFont
        self.valueNameColor = valueNameColor
        self.valueTextFont = valueTextFont
        self.valueTextEditableColor = valueTextEditableColor
        self.valueTextNotEditableColor = valueTextNotEditableColor
        self.valueTextBackgroundColor = valueTextBackgroundColor
        self.valueTextBorderColor = valueTextBorderColor
        self.minValue = minValue
        self.maxValue = maxValue
        self.allowDecimal = allowDecimal
        self.inputTextfieldWidth = inputTextfieldWidth
        self.isEditable = isEditable
        self.provider = provider
        self.actions = actions
    }
}

public protocol ReadingTextInputTableCellProvider: class {
    func getReadingTextInputValue(forIdentifier identifier: Any) -> String?
    func getReadingTextInputShouldEndEditing(forIdentifier identifier: Any) -> Bool?
}

public protocol ReadingTextInputTableCellActions: class {
    func onReadingTextInputValueChanged(forIdentifier identifier: Any, value: String?)
}
