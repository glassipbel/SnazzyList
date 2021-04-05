//
//  FormDoubleEntryTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 1/24/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a double entry text for your user.
/// The behavior of this cell can be really specific and it may not match your requirements, be sure that this cell behavior is a good fit for your needs before using it.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/FormDoubleEntryTableCell.png?raw=true
final class FormDoubleEntryTableCell: UITableViewCell {
    let leftContainerView = UIView(backgroundColor: .clear)
    let leftContainerBorderView = UIView(backgroundColor: .white)
    let leftTitleLabel = UILabel(font: .systemFont(ofSize: 12.0, weight: .medium), textColor: .black, textAlignment: .left)
    let leftInputStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4.0)
    let leftInputTextField = UITextField(placeholderText: nil, font: .systemFont(ofSize: 16.0, weight: .regular), textColor: .black, backgroundColor: .clear, borderStyle: .none, borderColor: .clear, placeholderTextColor: .clear, placeholderFont: nil, paddingLeft: 0.0, paddingRight: 0.0)
    let leftAttentionImageView = UIImageView(image: UIImage(named: "attention_small", in: Bundle.resourceBundle(for: FormDoubleEntryTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    let leftTapToAddLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .medium), textColor: .blue, textAlignment: .left)
    lazy var leftActionButton: UIButton = {
        return UIButton.getInvisible(target: self, action: #selector(tapLeftActionButton))
    }()
    
    let rightContainerView = UIView(backgroundColor: .clear)
    let rightContainerBorderView = UIView(backgroundColor: .white)
    let rightTitleLabel = UILabel(font: .systemFont(ofSize: 12.0, weight: .medium), textColor: .black, textAlignment: .left)
    let rightInputStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4.0)
    let rightInputTextField = UITextField(placeholderText: nil, font: .systemFont(ofSize: 16.0, weight: .regular), textColor: .black, backgroundColor: .clear, borderStyle: .none, borderColor: .clear, placeholderTextColor: .clear, placeholderFont: nil, paddingLeft: 0.0, paddingRight: 0.0)
    let rightAttentionImageView = UIImageView(image: UIImage(named: "attention_small", in: Bundle.resourceBundle(for: FormDoubleEntryTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    let rightTapToAddLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .medium), textColor: .blue, textAlignment: .left)
    lazy var rightActionButton: UIButton = {
        return UIButton.getInvisible(target: self, action: #selector(tapRightActionButton))
    }()
    
    let middleLineSeparationView = UIView(backgroundColor: .gray)
    let bottomLineSeparationView = UIView(backgroundColor: .gray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapLeftActionButton() {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.onFormDoubleEntryValueTap(forIdentifier: configFile.leftIdentifier)
        if configFile.provider?.getFormDoubleEntryIsKeyboardEditable(forIdentifier: configFile.leftIdentifier) == true {
            if let deleteString = configFile.provider?.getFormDoubleEntryDeleteStringBeforeEditing(forIdentifier: configFile.leftIdentifier) {
                leftInputTextField.text = leftInputTextField.text?.replacingOccurrences(of: deleteString, with: "")
            }
            leftInputTextField.becomeFirstResponder()
        }
        configureSelection()
    }
    
    @objc func tapRightActionButton() {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.onFormDoubleEntryValueTap(forIdentifier: configFile.rightIdentifier)
        if configFile.provider?.getFormDoubleEntryIsKeyboardEditable(forIdentifier: configFile.rightIdentifier) == true {
            if let deleteString = configFile.provider?.getFormDoubleEntryDeleteStringBeforeEditing(forIdentifier: configFile.rightIdentifier) {
                rightInputTextField.text = rightInputTextField.text?.replacingOccurrences(of: deleteString, with: "")
            }
            rightInputTextField.becomeFirstResponder()
        }
        configureSelection()
    }
    
    private var configFile: FormDoubleEntryTableCellConfigFile?
}

extension FormDoubleEntryTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? FormDoubleEntryTableCellConfigFile else { return }
        self.configFile = configFile
        
        let leftHasValue = configFile.provider?.getFormDoubleEntryValue(forIdentifier: configFile.leftIdentifier) != nil
        leftTitleLabel.text = configFile.provider?.getFormDoubleEntryTitle(forIdentifier: configFile.leftIdentifier)
        leftTitleLabel.font = configFile.leftTitleFont
        leftTitleLabel.textColor = configFile.leftTitleColor
        let leftTextValue = configFile.provider?.getFormDoubleEntryValue(forIdentifier: configFile.leftIdentifier)
        if let textFormat = configFile.leftTextFormat {
            let formatter = TextFormatter(textPattern: textFormat)
            leftInputTextField.text = formatter.formattedText(from: leftTextValue)
        } else {
            leftInputTextField.text = leftTextValue
        }
        
        leftInputTextField.font = configFile.leftInputTextFont
        leftInputTextField.textColor = configFile.leftInputTextColor
        leftInputTextField.isHidden = !leftHasValue
        leftInputTextField.autocorrectionType = .no
        leftInputTextField.autocapitalizationType = configFile.leftAutocapitalizationType
        leftInputTextField.keyboardType = configFile.leftKeyboardType
        leftAttentionImageView.isHidden = leftHasValue
        leftAttentionImageView.image = configFile.leftAttencionImage ?? UIImage(named: "attention_small", in: Bundle.resourceBundle(for: FormDoubleEntryTableCell.self), compatibleWith: nil)
        leftTapToAddLabel.isHidden = leftHasValue
        leftTapToAddLabel.text = configFile.leftAddText
        leftTapToAddLabel.font = configFile.leftAddTextFont
        leftTapToAddLabel.textColor = configFile.leftAddTextColor
        
        let rightHasValue = configFile.provider?.getFormDoubleEntryValue(forIdentifier: configFile.rightIdentifier) != nil
        rightTitleLabel.text = configFile.provider?.getFormDoubleEntryTitle(forIdentifier: configFile.rightIdentifier)
        let rightTextValue = configFile.provider?.getFormDoubleEntryValue(forIdentifier: configFile.rightIdentifier)
        if let textFormat = configFile.rightTextFormat {
            let formatter = TextFormatter(textPattern: textFormat)
            rightInputTextField.text = formatter.formattedText(from: rightTextValue)
        } else {
            rightInputTextField.text = rightTextValue
        }
        rightInputTextField.font = configFile.rightInputTextFont
        rightInputTextField.textColor = configFile.rightInputTextColor
        rightInputTextField.isHidden = !rightHasValue
        rightInputTextField.autocapitalizationType = configFile.rightAutocapitalizationType
        rightInputTextField.keyboardType = configFile.rightKeyboardType
        rightAttentionImageView.isHidden = rightHasValue
        rightAttentionImageView.image = configFile.rightAttencionImage ?? UIImage(named: "attention_small", in: Bundle.resourceBundle(for: FormDoubleEntryTableCell.self), compatibleWith: nil)
        rightTapToAddLabel.isHidden = rightHasValue
        rightTapToAddLabel.text = configFile.rightAddText
        rightTapToAddLabel.font = configFile.rightAddTextFont
        rightTapToAddLabel.textColor = configFile.rightAddTextColor
        
        bottomLineSeparationView.isHidden = !configFile.shouldShowBottomLine
        
        middleLineSeparationView.backgroundColor = configFile.middleLineColor
        bottomLineSeparationView.backgroundColor = configFile.underlineColor
        
        configureSelection()
    }
    
    private func configureSelection() {
        guard let configFile = self.configFile else { return }
        
        if configFile.provider?.getFormDoubleEntryIsEditing(forIdentifier: configFile.leftIdentifier) == true {
            leftContainerBorderView.layer.borderColor = configFile.leftContainerBorderColor.cgColor
            rightContainerBorderView.layer.borderColor = UIColor.clear.cgColor
            return
        }
        if configFile.provider?.getFormDoubleEntryIsEditing(forIdentifier: configFile.rightIdentifier) == true {
            rightContainerBorderView.layer.borderColor = configFile.rightContainerBorderColor.cgColor
            leftContainerBorderView.layer.borderColor = UIColor.clear.cgColor
            return
        }
        rightContainerBorderView.layer.borderColor = UIColor.clear.cgColor
        leftContainerBorderView.layer.borderColor = UIColor.clear.cgColor
    }
}

private extension FormDoubleEntryTableCell {
    private func setupViews() {
        setupBackground()
        setupMiddleLineSeparationView()
        setupBottomLineSeparationView()
        setupLeftContainerBorderView()
        setupLeftContainerView()
        setupLeftTitleLabel()
        setupLeftInputStackView()
        setupLeftInputTextField()
        setupLeftAttentionImageView()
        setupLeftTapToAddLabel()
        setupLeftActionButton()
        setupRightContainerBorderView()
        setupRightContainerView()
        setupRightTitleLabel()
        setupRightInputStackView()
        setupRightInputTextField()
        setupRightAttentionImageView()
        setupRightTapToAddLabel()
        setupRightActionButton()
    }
    
    private func setupMiddleLineSeparationView() {
        contentView.addSubview(middleLineSeparationView)
    }
    
    private func setupBottomLineSeparationView() {
        contentView.addSubview(bottomLineSeparationView)
    }
    
    private func setupLeftContainerView() {
        contentView.addSubview(leftContainerView)
    }
    
    private func setupLeftContainerBorderView() {
        leftContainerBorderView.layer.cornerRadius = 4.0
        leftContainerBorderView.layer.borderWidth = 2.0
        contentView.addSubview(leftContainerBorderView)
    }
    
    private func setupLeftTitleLabel() {
        leftTitleLabel.numberOfLines = 1
        leftContainerView.addSubview(leftTitleLabel)
    }
    
    private func setupLeftInputStackView() {
        leftContainerView.addSubview(leftInputStackView)
    }
    
    private func setupLeftInputTextField() {
        leftInputTextField.delegate = self
        leftInputTextField.minimumFontSize = 13.0
        leftInputTextField.adjustsFontSizeToFitWidth = true
        leftInputStackView.addArrangedSubview(leftInputTextField)
    }
    
    private func setupLeftAttentionImageView() {
        leftInputStackView.addArrangedSubview(leftAttentionImageView)
    }
    
    private func setupLeftTapToAddLabel() {
        leftTapToAddLabel.numberOfLines = 1
        leftInputStackView.addArrangedSubview(leftTapToAddLabel)
    }
    
    private func setupLeftActionButton() {
        leftContainerView.addSubview(leftActionButton)
    }
    
    private func setupRightContainerView() {
        contentView.addSubview(rightContainerView)
    }
    
    private func setupRightContainerBorderView() {
        rightContainerBorderView.layer.cornerRadius = 4.0
        rightContainerBorderView.layer.borderWidth = 2.0
        contentView.addSubview(rightContainerBorderView)
    }
    
    private func setupRightTitleLabel() {
        rightTitleLabel.numberOfLines = 1
        rightContainerView.addSubview(rightTitleLabel)
    }
    
    private func setupRightInputStackView() {
        rightContainerView.addSubview(rightInputStackView)
    }
    
    private func setupRightInputTextField() {
        rightInputTextField.delegate = self
        rightInputTextField.minimumFontSize = 13.0
        rightInputTextField.adjustsFontSizeToFitWidth = true
        rightInputStackView.addArrangedSubview(rightInputTextField)
    }
    
    private func setupRightAttentionImageView() {
        rightInputStackView.addArrangedSubview(rightAttentionImageView)
    }
    
    private func setupRightTapToAddLabel() {
        rightTapToAddLabel.numberOfLines = 1
        rightInputStackView.addArrangedSubview(rightTapToAddLabel)
    }
    
    private func setupRightActionButton() {
        rightContainerView.addSubview(rightActionButton)
    }
    
    private func setupConstraints() {
        middleLineSeparationView.bind(withConstant: 24.0, boundType: .vertical)
        middleLineSeparationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        middleLineSeparationView.assignSize(width: 1.0)
        
        bottomLineSeparationView.assignSize(height: 1.0)
        bottomLineSeparationView.bind(withConstant: 16.0, boundType: .horizontal)
        bottomLineSeparationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        leftContainerView.widthAnchor.constraint(equalTo: rightContainerView.widthAnchor).isActive = true
        
        leftContainerBorderView.bind(withConstant: 15.0, boundType: .vertical)
        leftContainerBorderView.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor).isActive = true
        leftContainerBorderView.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor).isActive = true
        
        leftContainerView.leftAnchor.constraint(equalTo: bottomLineSeparationView.leftAnchor).isActive = true
        leftContainerView.topAnchor.constraint(equalTo: middleLineSeparationView.topAnchor).isActive = true
        leftContainerView.bottomAnchor.constraint(equalTo: middleLineSeparationView.bottomAnchor).isActive = true
        leftContainerView.rightAnchor.constraint(equalTo: middleLineSeparationView.leftAnchor, constant: -4.0).isActive = true
        
        leftTitleLabel.topAnchor.constraint(equalTo: leftContainerView.topAnchor).isActive = true
        leftTitleLabel.bind(withConstant: 8.0, boundType: .horizontal)
        
        leftInputStackView.topAnchor.constraint(greaterThanOrEqualTo: leftTitleLabel.bottomAnchor, constant: 6.0).isActive = true
        leftInputStackView.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor).isActive = true
        leftInputStackView.bind(withConstant: 12.0, boundType: .horizontal)
        
        leftActionButton.pinEdges(to: leftInputStackView)
        
        leftAttentionImageView.assignSize(width: 16.0, height: 16.0)
        leftInputTextField.widthAnchor.constraint(equalTo: leftInputStackView.widthAnchor).isActive = true
        
        rightContainerBorderView.bind(withConstant: 15.0, boundType: .vertical)
        rightContainerBorderView.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor).isActive = true
        rightContainerBorderView.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor).isActive = true
        
        rightContainerView.leftAnchor.constraint(equalTo: middleLineSeparationView.rightAnchor, constant: 4.0).isActive = true
        rightContainerView.topAnchor.constraint(equalTo: middleLineSeparationView.topAnchor).isActive = true
        rightContainerView.bottomAnchor.constraint(equalTo: middleLineSeparationView.bottomAnchor).isActive = true
        rightContainerView.rightAnchor.constraint(equalTo: bottomLineSeparationView.rightAnchor).isActive = true
        
        rightTitleLabel.topAnchor.constraint(equalTo: rightContainerView.topAnchor).isActive = true
        rightTitleLabel.bind(withConstant: 8.0, boundType: .horizontal)
        
        rightInputStackView.topAnchor.constraint(greaterThanOrEqualTo: rightTitleLabel.bottomAnchor, constant: 6.0).isActive = true
        rightInputStackView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor).isActive = true
        rightInputStackView.bind(withConstant: 12.0, boundType: .horizontal)
        
        rightActionButton.pinEdges(to: rightInputStackView)
        
        rightAttentionImageView.assignSize(width: 16.0, height: 16.0)
        rightInputTextField.widthAnchor.constraint(equalTo: rightInputStackView.widthAnchor).isActive = true
    }
}

extension FormDoubleEntryTableCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let configFile = self.configFile else { return true }
        let isLeft = textField == leftInputTextField
        configFile.actions?.onFormDoubleEntryTapReturn(forIdentifier: isLeft ? configFile.leftIdentifier : configFile.rightIdentifier)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let value: String? = String(newString) == "" ? nil : String(newString)
        guard let configFile = self.configFile else { return false }
        
        var text: String? = value
        var unformattedText: String? = value
        
        let textFormat: String?
        let regex: String?
        let identifier: Any
        let attentionImageView: UIImageView
        let tapToAddLabel: UILabel
        
        let isLeft = textField == leftInputTextField
        
        if isLeft {
            textFormat = configFile.leftTextFormat
            regex = configFile.leftAllowedSymbolRegex
            identifier = configFile.leftIdentifier
            attentionImageView = leftAttentionImageView
            tapToAddLabel = leftTapToAddLabel
        } else {
            textFormat = configFile.rightTextFormat
            regex = configFile.rightAllowedSymbolRegex
            identifier = configFile.rightIdentifier
            attentionImageView = rightAttentionImageView
            tapToAddLabel = rightTapToAddLabel
        }
        
        if let textFormat = textFormat {
            let formatter = TextFormatter(textPattern: textFormat)
            let rightValue = formatter.unformattedText(from: value)
            let newText = formatter.formattedText(from: rightValue)
            text = newText == "" ? nil : newText
            let unformatted = formatter.unformattedText(from: newText)
            unformattedText = unformatted == "" ? nil : unformatted
        }
        
        if unformattedText?.isValidAgainst(regex: regex) == false { return false }
        textField.text = text
        textField.isHidden = text == nil
        attentionImageView.isHidden = !textField.isHidden
        tapToAddLabel.isHidden = !textField.isHidden
        configFile.actions?.onFormDoubleEntryTextChanged(text: unformattedText, forIdentifier: identifier)
        return false
    }
}

struct FormDoubleEntryTableCellConfigFile {
    let leftIdentifier: Any
    let rightIdentifier: Any
    let leftTextFormat: String?
    let leftKeyboardType: UIKeyboardType
    let leftAutocapitalizationType: UITextAutocapitalizationType
    let leftAllowedSymbolRegex: String?
    let leftTitleFont: UIFont
    let leftTitleColor: UIColor
    let leftInputTextColor: UIColor
    let leftInputTextFont: UIFont
    let leftAddText: String
    let leftAddTextColor: UIColor
    let leftAddTextFont: UIFont
    let leftAttencionImage: UIImage?
    let leftContainerBorderColor: UIColor
    let rightTextFormat: String?
    let rightKeyboardType: UIKeyboardType
    let rightAutocapitalizationType: UITextAutocapitalizationType
    let rightAllowedSymbolRegex: String?
    let rightTitleFont: UIFont
    let rightTitleColor: UIColor
    let rightInputTextColor: UIColor
    let rightInputTextFont: UIFont
    let rightAddText: String
    let rightAddTextColor: UIColor
    let rightAddTextFont: UIFont
    let rightAttencionImage: UIImage?
    let rightContainerBorderColor: UIColor
    let shouldShowBottomLine: Bool
    let middleLineColor: UIColor
    let underlineColor: UIColor
    
    weak var provider: FormDoubleEntryTableCellProvider?
    weak var actions: FormDoubleEntryTableCellActions?
    
    init(leftIdentifier: Any, rightIdentifier: Any, leftTextFormat: String?, leftKeyboardType: UIKeyboardType, leftAutocapitalizationType: UITextAutocapitalizationType, leftAllowedSymbolRegex: String?, leftTitleFont: UIFont, leftTitleColor: UIColor, leftInputTextColor: UIColor, leftInputTextFont: UIFont, leftAddText: String, leftAddTextColor: UIColor, leftAddTextFont: UIFont, leftAttentionImage: UIImage?, leftContainerBorderColor: UIColor, rightTextFormat: String?, rightKeyboardType: UIKeyboardType, rightAutocapitalizationType: UITextAutocapitalizationType, rightAllowedSymbolRegex: String?, rightTitleFont: UIFont, rightTitleColor: UIColor, rightInputTextColor: UIColor, rightInputTextFont: UIFont, rightAddTextColor: UIColor, rightAddText: String, rightAddTextFont: UIFont, rightAttencionImage: UIImage?, rightContainerBorderColor: UIColor, shouldShowBottomLine: Bool, middleLineColor: UIColor, underlineColor: UIColor, provider: FormDoubleEntryTableCellProvider?, actions: FormDoubleEntryTableCellActions?) {
        self.leftIdentifier = leftIdentifier
        self.rightIdentifier = rightIdentifier
        self.leftTextFormat = leftTextFormat
        self.leftKeyboardType = leftKeyboardType
        self.leftAutocapitalizationType = leftAutocapitalizationType
        self.leftAllowedSymbolRegex = leftAllowedSymbolRegex
        self.leftTitleFont = leftTitleFont
        self.leftTitleColor = leftTitleColor
        self.leftInputTextColor = leftInputTextColor
        self.leftInputTextFont = leftInputTextFont
        self.leftAddText = leftAddText
        self.leftAddTextColor = leftAddTextColor
        self.leftAddTextFont = leftAddTextFont
        self.leftAttencionImage = leftAttentionImage
        self.leftContainerBorderColor = leftContainerBorderColor
        self.rightTextFormat = rightTextFormat
        self.rightKeyboardType = rightKeyboardType
        self.rightAutocapitalizationType = rightAutocapitalizationType
        self.rightAllowedSymbolRegex = rightAllowedSymbolRegex
        self.rightAddText = rightAddText
        self.rightTitleFont = rightTitleFont
        self.rightTitleColor = rightTitleColor
        self.rightInputTextColor = rightInputTextColor
        self.rightInputTextFont = rightInputTextFont
        self.rightAddTextColor = rightAddTextColor
        self.rightAddTextFont = rightAddTextFont
        self.rightAttencionImage = rightAttencionImage
        self.rightContainerBorderColor = rightContainerBorderColor
        self.shouldShowBottomLine = shouldShowBottomLine
        self.middleLineColor = middleLineColor
        self.underlineColor = underlineColor
        
        self.provider = provider
        self.actions = actions
    }
}

public protocol FormDoubleEntryTableCellProvider: class {
    func getFormDoubleEntryTitle(forIdentifier identifier: Any) -> String
    func getFormDoubleEntryIsEditing(forIdentifier identifier: Any) -> Bool
    func getFormDoubleEntryValue(forIdentifier identifier: Any) -> String?
    func getFormDoubleEntryIsKeyboardEditable(forIdentifier identifier: Any) -> Bool
    func getFormDoubleEntryDeleteStringBeforeEditing(forIdentifier identifier: Any) -> String?
}

public protocol FormDoubleEntryTableCellActions: class {
    func onFormDoubleEntryValueTap(forIdentifier identifier: Any)
    func onFormDoubleEntryTapReturn(forIdentifier identifier: Any)
    func onFormDoubleEntryTextChanged(text: String?, forIdentifier identifier: Any)
}
