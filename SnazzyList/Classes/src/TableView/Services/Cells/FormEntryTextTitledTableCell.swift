//
//  FormEntryTextTitledTableCell.swift
//  Dms
//
//  Created by Kevin on 10/3/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show TextField for your user to input data with a title on top.
/// We also have another type of cell TextFieldFormattedInputTableCell that may fit your needs better.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/FormEntryTextTitledTableCell.png?raw=true
final class FormEntryTextTitledTableCell: UITableViewCell {
    let titleLabel = UILabel(font: .systemFont(ofSize: 12.0, weight: .medium), textColor: .blue, textAlignment: .left)
    let entryTextField = UITextField(placeholderText: "", font: .systemFont(ofSize: 17.0, weight: .medium), textColor: .black, backgroundColor: .clear, borderStyle: .none, borderColor: .clear, placeholderTextColor: .gray, paddingLeft: 0.0, paddingRight: 0.0)
    let bottomLineView = UIView(backgroundColor: .blue)
    let scrimView = UIView(backgroundColor: UIColor.white.withAlphaComponent(0.6))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: FormEntryTextTitledTableCellConfigFile?
}

extension FormEntryTextTitledTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? FormEntryTextTitledTableCellConfigFile else { return }
        self.configFile = configFile
        
        let textValue = configFile.provider?.getFormEntryTextTitledTableValue(forIdentifier: configFile.identifier)
        let placeholder = configFile.provider?.getFormEntryTextTitledTablePlaceholder(forIdentifier: configFile.identifier) ?? ""
        let required = configFile.provider?.getFormEntryTextTitledTableRequired(forIdentifier: configFile.identifier) ?? false
        self.entryTextField.isUserInteractionEnabled = configFile.isEditable
        
        titleLabel.text = placeholder
        titleLabel.font = configFile.titleFont
        titleLabel.textColor = configFile.titleColor
        titleLabel.isHidden = textValue == nil
        entryTextField.text = textValue
        entryTextField.textColor = configFile.entryTextColor
        entryTextField.font = configFile.entryTextFont
        entryTextField.keyboardType = configFile.keyboardType
        entryTextField.autocapitalizationType = configFile.autocapitalizationType
        entryTextField.autocorrectionType = configFile.autocorrectionType
        entryTextField.returnKeyType = configFile.returnKeyType
        
        let attrPlaceholder = (placeholder + (required ? "" : " (" + configFile.entryTextPlaceholder.uppercased() + ")")).getAttributedStringWithLetterSpacing(spacing: 0.0, font: configFile.entryTextFont, color: configFile.entryTextPlaceholderColor)
        entryTextField.attributedPlaceholder = attrPlaceholder
        scrimView.isHidden = configFile.isEditable
        bottomLineView.backgroundColor = configFile.underlineColor
    }
}

extension FormEntryTextTitledTableCell {
    private func setupViews() {
        setupBackground()
        setupTitleLabel()
        setupEntryTextField()
        setupBottomLineView()
        setupScrimView()
    }
    
    private func setupScrimView() {
        contentView.addSubview(scrimView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
    }
    
    private func setupEntryTextField() {
        entryTextField.delegate = self
        contentView.addSubview(entryTextField)
    }
    
    private func setupBottomLineView() {
        contentView.addSubview(bottomLineView)
    }
    
    private func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0).isActive = true
        titleLabel.bind(withConstant: 16.0, boundType: .horizontal)
        
        entryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0).isActive = true
        entryTextField.assignSize(height: 26.0)
        entryTextField.bind(withConstant: 16.0, boundType: .horizontal)
        
        bottomLineView.topAnchor.constraint(equalTo: entryTextField.bottomAnchor, constant: 8.0).isActive = true
        bottomLineView.assignSize(height: 2.0)
        bottomLineView.bind(withConstant: 16.0, boundType: .horizontal)
        bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        scrimView.matchEdges(to: entryTextField)
    }
}

extension FormEntryTextTitledTableCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = self.configFile?.maxLength ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length <= maxLength {
            let value: String? = String(newString) == "" ? nil : String(newString)
            titleLabel.isHidden = value == nil
            if let configFile = self.configFile {
                configFile.actions?.onFormEntryTextTitledTableValueChanged(value: value, forIdentifier: configFile.identifier)
            }
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let configFile = self.configFile else { return true }
        configFile.actions?.onFormEntryTextTitleTableTapReturn?(forIdentifier: configFile.identifier)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let configFile = self.configFile else { return }
        
        if configFile.shouldHideKeyboard {
            textField.resignFirstResponder()
        }
        
        configFile
            .actions?
            .onFormEntryTextFieldDidBeginEditing?(
                forIdentifier: configFile.identifier
        )
    }
}

struct FormEntryTextTitledTableCellConfigFile {
    let identifier: Any
    let titleFont: UIFont
    let titleColor: UIColor
    let entryTextFont: UIFont
    let entryTextColor: UIColor
    let entryTextPlaceholder: String
    let entryTextPlaceholderColor: UIColor
    let underlineColor: UIColor
    let isEditable: Bool
    let maxLength: Int?
    let keyboardType: UIKeyboardType
    let autocapitalizationType: UITextAutocapitalizationType
    let autocorrectionType: UITextAutocorrectionType
    let returnKeyType: UIReturnKeyType
    let shouldHideKeyboard: Bool
    
    weak var provider: FormEntryTextTitledTableProvider?
    weak var actions: FormEntryTextTitledTableActions?
    
    init(identifier: Any, isEditable: Bool, titleFont: UIFont, titleColor: UIColor, entryTextFont: UIFont, entryTextColor: UIColor, entryTextPlaceholder: String, entryTextPlaceholderColor: UIColor, underlineColor: UIColor, maxLength: Int?, keyboardType: UIKeyboardType, autocapitalizationType: UITextAutocapitalizationType, autocorrectionType: UITextAutocorrectionType, returnKeyType: UIReturnKeyType, shouldHideKeyboard: Bool = false, provider: FormEntryTextTitledTableProvider?, actions: FormEntryTextTitledTableActions?) {
        self.identifier = identifier
        self.isEditable = isEditable
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.entryTextFont = entryTextFont
        self.entryTextColor = entryTextColor
        self.entryTextPlaceholder = entryTextPlaceholder
        self.entryTextPlaceholderColor = entryTextPlaceholderColor
        self.underlineColor = underlineColor
        self.maxLength = maxLength
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.returnKeyType = returnKeyType
        self.shouldHideKeyboard = shouldHideKeyboard
        self.provider = provider
        self.actions = actions
    }
}

public protocol FormEntryTextTitledTableProvider: class {
    func getFormEntryTextTitledTablePlaceholder(forIdentifier identifier: Any) -> String
    func getFormEntryTextTitledTableRequired(forIdentifier identifier: Any) -> Bool
    func getFormEntryTextTitledTableValue(forIdentifier identifier: Any) -> String?
}

@objc public protocol FormEntryTextTitledTableActions: class {
    func onFormEntryTextTitledTableValueChanged(value: String?, forIdentifier identifier: Any)
    @objc optional func onFormEntryTextTitleTableTapReturn(forIdentifier identifier: Any)
    @objc optional func onFormEntryTextFieldDidBeginEditing(forIdentifier identifier: Any)
}
