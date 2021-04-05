//
//  FormSingleEntryTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 8/13/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a single entry text for your user.
/// The behavior of this cell can be really specific and it may not match your requirements, be sure that this cell behavior is a good fit for your needs before using it.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/FormDoubleEntryTableCell.png?raw=true
final class FormSingleEntryTableCell: UITableViewCell {
    let containerView = UIView(backgroundColor: .clear)
    let containerBorderView = UIView(backgroundColor: .white)
    let titleLabel = UILabel(font: .systemFont(ofSize: 12.0, weight: .medium), textColor: .black, textAlignment: .left)
    let inputStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4.0)
    let inputTextField = UITextField(placeholderText: nil, font: .systemFont(ofSize: 16.0, weight: .regular), textColor: .black, backgroundColor: .clear, borderStyle: .none, borderColor: .clear, placeholderTextColor: .clear, placeholderFont: nil, paddingLeft: 0.0, paddingRight: 0.0)
    let attentionImageView = UIImageView(image: UIImage(named: "attention_small", in: Bundle.resourceBundle(for: FormSingleEntryTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    let tapToAddLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .medium), textColor: .black, textAlignment: .left)
    lazy var actionButton: UIButton = {
        return UIButton.getInvisible(target: self, action: #selector(tapActionButton))
    }()
    let bottomLineSeparationView = UIView(backgroundColor: .gray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapActionButton() {
        guard let configFile = self.configFile else { return }
        configFile.actions?.onFormSingleEntryValueTap(forIdentifier: configFile.identifier)
        if configFile.provider?.getFormSingleEntryIsKeyboardEditable(forIdentifier: configFile.identifier) == true {
            inputTextField.becomeFirstResponder()
        }
        configureSelection()
    }
    
    private var configFile: FormSingleEntryTableCellConfigFile?
}

extension FormSingleEntryTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? FormSingleEntryTableCellConfigFile else { return }
        self.configFile = configFile
        
        let hasValue = configFile.provider?.getFormSingleEntryValue(forIdentifier: configFile.identifier) != nil
        titleLabel.text = configFile.provider?.getFormSingleEntryTitle(forIdentifier: configFile.identifier)
        let textValue = configFile.provider?.getFormSingleEntryValue(forIdentifier: configFile.identifier)
        if let textFormat = configFile.textFormat {
            let formatter = TextFormatter(textPattern: textFormat)
            inputTextField.text = formatter.formattedText(from: textValue)
        } else {
            inputTextField.text = textValue
        }
        inputTextField.isHidden = !hasValue
        inputTextField.autocorrectionType = .no
        inputTextField.autocapitalizationType = configFile.autocapitalizationType
        inputTextField.keyboardType = configFile.keyboardType
        attentionImageView.isHidden = hasValue
        tapToAddLabel.isHidden = hasValue
        tapToAddLabel.text = configFile.addText
        
        bottomLineSeparationView.isHidden = !configFile.shouldShowBottomLine
        bottomLineSeparationView.backgroundColor = configFile.underlineColor
        configureSelection()
    }
    
    private func configureSelection() {
        guard let configFile = self.configFile else { return }
        
        let isEditing = configFile.provider?.getFormSingleEntryIsEditing(forIdentifier: configFile.identifier) == true
        containerBorderView.layer.borderColor = isEditing ? configFile.containerEditingColor.cgColor : configFile.containerNotEditingColor.cgColor
    }
}

private extension FormSingleEntryTableCell {
    private func setupViews() {
        setupBackground()
        setupBottomLineSeparationView()
        setupContainerBorderView()
        setupContainerView()
        setupTitleLabel()
        setupInputStackView()
        setupInputTextField()
        setupAttentionImageView()
        setupTapToAddLabel()
        setupActionButton()
    }
    
    private func setupBottomLineSeparationView() {
        contentView.addSubview(bottomLineSeparationView)
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
    }
    
    private func setupContainerBorderView() {
        containerBorderView.layer.cornerRadius = 4.0
        containerBorderView.layer.borderWidth = 2.0
        contentView.addSubview(containerBorderView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        containerView.addSubview(titleLabel)
    }
    
    private func setupInputStackView() {
        containerView.addSubview(inputStackView)
    }
    
    private func setupInputTextField() {
        inputTextField.delegate = self
        inputTextField.minimumFontSize = 13.0
        inputTextField.adjustsFontSizeToFitWidth = true
        inputStackView.addArrangedSubview(inputTextField)
    }
    
    private func setupAttentionImageView() {
        inputStackView.addArrangedSubview(attentionImageView)
    }
    
    private func setupTapToAddLabel() {
        tapToAddLabel.numberOfLines = 1
        inputStackView.addArrangedSubview(tapToAddLabel)
    }
    
    private func setupActionButton() {
        containerView.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        bottomLineSeparationView.assignSize(height: 1.0)
        bottomLineSeparationView.bind(withConstant: 16.0, boundType: .horizontal)
        bottomLineSeparationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        containerBorderView.bind(withConstant: 15.0, boundType: .vertical)
        containerBorderView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        containerBorderView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        containerView.leftAnchor.constraint(equalTo: bottomLineSeparationView.leftAnchor).isActive = true
        containerView.bind(withConstant: 24.0, boundType: .vertical)
        containerView.rightAnchor.constraint(equalTo: bottomLineSeparationView.rightAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        titleLabel.bind(withConstant: 8.0, boundType: .horizontal)
        
        inputStackView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 6.0).isActive = true
        inputStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        inputStackView.bind(withConstant: 12.0, boundType: .horizontal)
        
        actionButton.pinEdges(to: inputStackView)
        
        attentionImageView.assignSize(width: 16.0, height: 16.0)
        inputTextField.widthAnchor.constraint(equalTo: inputStackView.widthAnchor).isActive = true
    }
}

extension FormSingleEntryTableCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let configFile = self.configFile else { return true }
        configFile.actions?.onFormSingleEntryTapReturn(forIdentifier: configFile.identifier)
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
        
        let textFormat = configFile.textFormat
        let regex = configFile.allowedSymbolRegex
        let identifier = configFile.identifier
        
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
        configFile.actions?.onFormSingleEntryTextChanged(text: unformattedText, forIdentifier: identifier)
        return false
    }
}

struct FormSingleEntryTableCellConfigFile {
    let identifier: Any
    let titleFont: UIFont
    let titleColor: UIColor
    let inputTextFont: UIFont
    let inputTextColor: UIColor
    let attentionImage: UIImage?
    let addText: String
    let addTextColor: UIColor
    let addTextFont: UIFont
    let textFormat: String?
    let keyboardType: UIKeyboardType
    let autocapitalizationType: UITextAutocapitalizationType
    let allowedSymbolRegex: String?
    let shouldShowBottomLine: Bool
    let underlineColor: UIColor
    let containerEditingColor: UIColor
    let containerNotEditingColor: UIColor
    
    weak var provider: FormSingleEntryTableCellProvider?
    weak var actions: FormSingleEntryTableCellActions?
    
    init(identifier: Any, titleFont: UIFont, titleColor: UIColor, inputTextFont: UIFont, inputTextColor: UIColor, attentionImage: UIImage?, addText: String, addTextColor: UIColor, addTextFont: UIFont, textFormat: String?, keyboardType: UIKeyboardType, autocapitalizationType: UITextAutocapitalizationType, allowedSymbolRegex: String?, shouldShowBottomLine: Bool, underlineColor: UIColor = .clear, containerEditingColor: UIColor, containerNotEditingColor: UIColor, provider: FormSingleEntryTableCellProvider?, actions: FormSingleEntryTableCellActions?) {
        self.identifier = identifier
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.inputTextFont = inputTextFont
        self.inputTextColor = inputTextColor
        self.attentionImage = attentionImage
        self.addText = addText
        self.addTextColor = addTextColor
        self.addTextFont = addTextFont
        self.textFormat = textFormat
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.allowedSymbolRegex = allowedSymbolRegex
        self.shouldShowBottomLine = shouldShowBottomLine
        self.underlineColor = underlineColor
        self.containerEditingColor = containerEditingColor
        self.containerNotEditingColor = containerNotEditingColor
        
        self.provider = provider
        self.actions = actions
    }
}

public protocol FormSingleEntryTableCellProvider: class {
    func getFormSingleEntryTitle(forIdentifier identifier: Any) -> String
    func getFormSingleEntryIsEditing(forIdentifier identifier: Any) -> Bool
    func getFormSingleEntryValue(forIdentifier identifier: Any) -> String?
    func getFormSingleEntryIsKeyboardEditable(forIdentifier identifier: Any) -> Bool
}

public protocol FormSingleEntryTableCellActions: class {
    func onFormSingleEntryValueTap(forIdentifier identifier: Any)
    func onFormSingleEntryTapReturn(forIdentifier identifier: Any)
    func onFormSingleEntryTextChanged(text: String?, forIdentifier identifier: Any)
}
