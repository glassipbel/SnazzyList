//
//  TextFieldFormattedInputTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 1/9/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show TextField for your user to input data with a title on top but also having a format attach to it, for example like a number (123) 123-4567 or even sending a regex for the allowed characters (for example just numbers) it will also work when you need to input secure text.
/// We also have another type of cell TextFieldFormattedInputTableCell that may fit your needs better.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextFieldFormattedInputTableCell.png?raw=true
/// Screenshot 2: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextFieldFormattedInputTableCell2.png?raw=true
final class TextFieldFormattedInputTableCell: UITableViewCell {
    let titleLabel = UILabel(font: .systemFont(ofSize: 12.0, weight: .medium), textColor: .blue, textAlignment: .left)
    let entryTextField = UITextField(placeholderText: "", font: .systemFont(ofSize: 18.0, weight: .medium), textColor: .black, backgroundColor: .clear, borderStyle: .none, borderColor: .clear, placeholderTextColor: .gray, placeholderFont: .systemFont(ofSize: 12.0, weight: .medium), paddingLeft: 0.0, paddingRight: 0.0)
    let bottomLineView = UIView(backgroundColor: .gray)
    
    
    
    let secureImageView = UIImageView(image: UIImage(named: "eye_enabled", in: Bundle.resourceBundle(for: TextFieldFormattedInputTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    lazy var secureButton: UIButton = {
        return UIButton.getInvisible(target: self, action: #selector(tapSecure))
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapSecure() {
        guard let configFile = self.configFile else { return }
        configFile.actions?.onTextFieldFormattedInputTapSecure(forIdentifier: configFile.identifier)
        configureSecure()
    }

    private var configFile: TextFieldFormattedInputTableCellConfigFile?
    private var lastReplacementString: String?
}

extension TextFieldFormattedInputTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? TextFieldFormattedInputTableCellConfigFile else { return }
        self.configFile = configFile

        let textValue = configFile.provider?.getTextFieldFormattedInputTableText(forIdentifier: configFile.identifier)
        let title = configFile.title
        
        titleLabel.text = title
        titleLabel.isHidden = textValue == nil
        titleLabel.textColor = configFile.titleColor
        titleLabel.font = configFile.titleFont
        if let textFormat = configFile.textFormat {
            let formatter = TextFormatter(textPattern: textFormat )
            entryTextField.text = formatter.formattedText(from: textValue)
        } else {
            entryTextField.text = textValue
        }
        entryTextField.setPlaceholder(placeholder: configFile.title, placeholderFont: configFile.entryPlaceholderFont, placeholderColor: configFile.entryPlaceholderColor)
        secureImageView.isHidden = !configFile.isSecure || textValue == nil
        secureImageView.isHidden = configFile.shouldShowEye ? secureImageView.isHidden : true
        secureButton.isHidden = secureImageView.isHidden
        entryTextField.keyboardType = configFile.keyboardType
        entryTextField.isEnabled = configFile.isEditable
        entryTextField.isUserInteractionEnabled = configFile.isEditable
        entryTextField.autocapitalizationType = configFile.autocapitalizationType
        configureSecure()
        
        bottomLineView.assignSize(height: configFile.bottomLineHeight)
        bottomLineView.backgroundColor = configFile.bottomLineColor
    }
    
    private func configureSecure() {
        guard let configFile = self.configFile else { return }
        let isShowingSecure = configFile.provider?.getTextFieldFormattedInputIsShowingSecure(forIdentifier: configFile.identifier) ?? false

        if isShowingSecure {
            secureImageView.image = configFile.secureOnIcon ?? UIImage(named: "eye_disabled", in: Bundle.resourceBundle(for: TextFieldFormattedInputTableCell.self), compatibleWith: nil)
        } else {
            secureImageView.image = configFile.secureOffIcon ?? UIImage(named: "eye_enabled", in: Bundle.resourceBundle(for: TextFieldFormattedInputTableCell.self), compatibleWith: nil)
        }
        
        entryTextField.isSecureTextEntry = isShowingSecure
        entryTextField.returnKeyType = configFile.returnKeyType
    }
}

extension TextFieldFormattedInputTableCell {
    private func setupViews() {
        setupBackground()
        setupTitleLabel()
        setupEntryTextField()
        setupBottomLineView()
        setupSecureImageView()
        setupSecureButton()
    }

    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
    }

    private func setupEntryTextField() {
        entryTextField.delegate = self
        entryTextField.autocorrectionType = .no
        entryTextField.autocapitalizationType = .words
        contentView.addSubview(entryTextField)
    }

    private func setupBottomLineView() {
        contentView.addSubview(bottomLineView)
    }
    
    private func setupSecureImageView() {
        contentView.addSubview(secureImageView)
    }
    
    private func setupSecureButton() {
        contentView.addSubview(secureButton)
    }

    private func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0).isActive = true
        titleLabel.bind(withConstant: 20.0, boundType: .horizontal)

        entryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
        entryTextField.assignSize(height: 26.0)
        entryTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0).isActive = true
        entryTextField.rightAnchor.constraint(equalTo: secureImageView.leftAnchor, constant: -8.0).isActive = true
        
        secureImageView.assignSize(width: 24.0, height: 24.0)
        secureImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0).isActive = true
        secureImageView.centerYAnchor.constraint(equalTo: entryTextField.centerYAnchor).isActive = true
        
        secureButton.centerYAnchor.constraint(equalTo: secureImageView.centerYAnchor).isActive = true
        secureButton.centerXAnchor.constraint(equalTo: secureImageView.centerXAnchor).isActive = true
        secureButton.assignSize(width: 40.0, height: 40.0)

        bottomLineView.topAnchor.constraint(equalTo: entryTextField.bottomAnchor, constant: 8.0).isActive = true
        bottomLineView.assignSize(height: 2.0)
        bottomLineView.bind(withConstant: 20.0, boundType: .horizontal)
        bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

extension TextFieldFormattedInputTableCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let configFile = self.configFile else { return true }
        configFile.actions?.onTextFieldFormattedInputTableTapReturn(forIdentifier: configFile.identifier)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let configFile = self.configFile else { return }
        configFile.actions?.onTextFieldFormattedInputTableSetFocus?(forIdentifier: configFile.identifier)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // fix of infinite loop when using swipe keyboard.
        // By one hypothesis swipe keyboard inserts the text and then tries to decide
        // what word was meant and that triggers another shouldChangeCharactersIn call
        // that causes an infinite loop
        // to break that infinite loop we should return true if replacementString is the same as on previous iteration
        if let lastString = lastReplacementString, string.count > 1 && string == lastString {
            return false
        }
        lastReplacementString = nil
        //---
        
        guard let configFile = self.configFile else { return false }
        
        let currentString: NSString = (textField.text ?? "") as NSString
        if !currentString.hasRange(range) { return false }
        
        let inputStringStripped = configFile.shouldSkipSpaces ? string.replacingOccurrences(of: " ", with: "") : string
        let newString: NSString = currentString.replacingCharacters(in: range, with: inputStringStripped) as NSString
        let value: String? = String(newString) == "" ? nil : String(newString)

        var text: String? = value
        var unformattedText: String? = value
        
        if let textFormat = configFile.textFormat {
            let formatter = TextFormatter(textPattern: textFormat)
            let rightValue = formatter.unformattedText(from: value)
            let newText = formatter.formattedText(from: rightValue)
            text = newText == "" ? nil : newText
            let unformatted = formatter.unformattedText(from: newText)
            unformattedText = unformatted == "" ? nil : unformatted
        }
        
        if unformattedText?.isValidAgainst(regex: configFile.allowedSymbolRegex) == false { return false }
        
        var oldCursorPosition: Int? = nil
        var wasAMultipleSelection = false
        if let selectedRange = entryTextField.selectedTextRange {
            oldCursorPosition = entryTextField.offset(from: entryTextField.beginningOfDocument, to: selectedRange.start)
            wasAMultipleSelection = selectedRange.start != selectedRange.end
        }
        
        lastReplacementString = string
        entryTextField.text = text
        secureImageView.isHidden = !configFile.isSecure || text == nil
        secureImageView.isHidden = configFile.shouldShowEye ? secureImageView.isHidden : true
        secureButton.isHidden = secureImageView.isHidden
        titleLabel.isHidden = text == nil
        
        if let oldCursorPosition = oldCursorPosition, configFile.textFormat == nil {
            let offset: Int
            if string == "" {
                //The user is deleting.
                offset = oldCursorPosition - (wasAMultipleSelection ? 0 : 1)
            } else {
                //The user is entering new strings.
                offset = oldCursorPosition + inputStringStripped.count
            }
            
            if let newPosition = entryTextField.position(from: entryTextField.beginningOfDocument, offset: offset) {
                DispatchQueue.main.async { [weak self] in
                    self?.entryTextField.selectedTextRange = self?.entryTextField.textRange(from: newPosition, to: newPosition)
                }
            }
        }
        
        configFile.actions?.onTextFieldFormattedInputTableTextChanged(text: unformattedText, forIdentifier: configFile.identifier)
        return false
    }
}

struct TextFieldFormattedInputTableCellConfigFile {
    let identifier: Any
    
    let isSecure: Bool
    let secureOnIcon: UIImage?
    let secureOffIcon: UIImage?
    let textFormat: String?
    let title: String
    let titleFont: UIFont
    let titleColor: UIColor
    let entryTextFont: UIFont
    let entryTextColor: UIColor
    let entryPlaceholderFont: UIFont
    let entryPlaceholderColor: UIColor
    let isEditable: Bool
    let keyboardType: UIKeyboardType
    let returnKeyType: UIReturnKeyType
    let autocapitalizationType: UITextAutocapitalizationType
    let allowedSymbolRegex: String?
    let shouldShowEye: Bool
    let bottomLineColor: UIColor
    let bottomLineHeight: CGFloat
    let shouldSkipSpaces: Bool

    weak var provider: TextFieldFormattedInputTableProvider?
    weak var actions: TextFieldFormattedInputTableActions?

    init(identifier: Any, title: String, titleFont: UIFont, titleColor: UIColor, entryTextFont: UIFont, entryTextColor: UIColor, entryPlaceholderFont: UIFont, entryPlaceholderColor: UIColor, isSecure: Bool, secureOnIcon: UIImage?, secureOffIcon: UIImage?, isEditable: Bool, textFormat: String?, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType, autocapitalizationType: UITextAutocapitalizationType, allowedSymbolRegex: String?, shouldShowEye: Bool, bottomLineColor: UIColor, bottomLineHeight: CGFloat = 2, shouldSkipSpaces: Bool, provider: TextFieldFormattedInputTableProvider?, actions: TextFieldFormattedInputTableActions?) {
        self.identifier = identifier
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.entryTextFont = entryTextFont
        self.entryTextColor = entryTextColor
        self.entryPlaceholderFont = entryPlaceholderFont
        self.entryPlaceholderColor = entryPlaceholderColor
        self.isSecure = isSecure
        self.secureOnIcon = secureOnIcon
        self.secureOffIcon = secureOffIcon
        self.textFormat = textFormat
        self.isEditable = isEditable
        self.provider = provider
        self.actions = actions
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.allowedSymbolRegex = allowedSymbolRegex
        self.autocapitalizationType = autocapitalizationType
        self.shouldShowEye = shouldShowEye
        self.bottomLineColor = bottomLineColor
        self.bottomLineHeight = bottomLineHeight
        self.shouldSkipSpaces = shouldSkipSpaces
    }
}

public protocol TextFieldFormattedInputTableProvider: class {
    func getTextFieldFormattedInputTableText(forIdentifier identifier: Any) -> String?
    func getTextFieldFormattedInputIsShowingSecure(forIdentifier identifier: Any) -> Bool
}

@objc public protocol TextFieldFormattedInputTableActions: class {
    func onTextFieldFormattedInputTableTapReturn(forIdentifier identifier: Any)
    func onTextFieldFormattedInputTableTextChanged(text: String?, forIdentifier identifier: Any)
    func onTextFieldFormattedInputTapSecure(forIdentifier identifier: Any)
    @objc optional func onTextFieldFormattedInputTableSetFocus(forIdentifier identifier: Any)
}

