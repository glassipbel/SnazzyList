//
//  TextFieldEntryTableCell.swift
//  Dms
//
//  Created by Kevin on 9/25/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show a TextField so the user can enter information. This is the basic one, if you need one more complex with title, you should use TextFieldFormattedInputTableCell or FormEntryTextTitledTableCell.
/// The size can be define for yours needs.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextFieldEntryTableCell.png?raw=true
final class TextFieldEntryTableCell: UITableViewCell {
    let titleTextField = UITextField(placeholderText: "", font: .systemFont(ofSize: 17.0, weight: .medium))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: TextFieldEntryTableCellConfigFile?
}

extension TextFieldEntryTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? TextFieldEntryTableCellConfigFile else { return }
        
        self.configFile = configFile
        
        titleTextField.text = configFile.provider?.getTextFieldEntryText(forIdentifier: configFile.identifier)
        titleTextField.font = configFile.titleFont
        titleTextField.textColor = configFile.titleColor
        titleTextField.placeholder = configFile.placeholder
        titleTextField.layer.cornerRadius = configFile.cornerRadius
        titleTextField.keyboardType = configFile.keyboardType
        titleTextField.autocapitalizationType = configFile.autocapitalizationType
        titleTextField.autocorrectionType = configFile.autocorrectionType
        titleTextField.returnKeyType = configFile.returnKeyType
        if configFile.showClearButton {
            titleTextField.rightView = nil
            titleTextField.clearButtonMode = .always
        } else {
            titleTextField.configurePaddingRight()
            titleTextField.clearButtonMode = .never
        }
    }
}

extension TextFieldEntryTableCell {
    private func setupViews() {
        setupBackground()
        setupTitleTextField()
    }
    
    private func setupTitleTextField() {
        titleTextField.delegate = self
        contentView.addSubview(titleTextField)
    }
    
    private func setupConstraints() {
        titleTextField.bind(withConstant: 8.0, boundType: .vertical)
        titleTextField.bind(withConstant: 16.0, boundType: .horizontal)
        titleTextField.assignSize(height: 52.0)
    }
}

extension TextFieldEntryTableCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let configFile = self.configFile else { return false }
        
        let maxLength = configFile.maxLength ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length <= maxLength {
            configFile.actions?.onTextFieldEntryChanged(text: String(newString), forIdentifier: configFile.identifier)
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let configFile = configFile {
            configFile.actions?.onTextFieldEntryChanged(text: "", forIdentifier: configFile.identifier)
        }
        return true
    }
}

struct TextFieldEntryTableCellConfigFile {
    let identifier: Any
    let titleFont: UIFont
    let titleColor: UIColor
    let placeholder: String
    let maxLength: Int?
    let cornerRadius: CGFloat
    let keyboardType: UIKeyboardType
    let autocapitalizationType: UITextAutocapitalizationType
    let autocorrectionType: UITextAutocorrectionType
    let returnKeyType: UIReturnKeyType
    let showClearButton: Bool
    
    weak var provider: TextFieldEntryTableProvider?
    weak var actions: TextFieldEntryTableActions?
    
    init(identifier: Any, titleFont: UIFont, titleColor: UIColor, placeholder: String, maxLength: Int?, cornerRadius: CGFloat, keyboardType: UIKeyboardType, autocapitalizationType: UITextAutocapitalizationType, autocorrectionType: UITextAutocorrectionType, returnKeyType: UIReturnKeyType, showClearButton: Bool, provider: TextFieldEntryTableProvider?, actions: TextFieldEntryTableActions?) {
        self.identifier = identifier
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.placeholder = placeholder
        self.maxLength = maxLength
        self.cornerRadius = cornerRadius
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.returnKeyType = returnKeyType
        self.showClearButton = showClearButton
        self.provider = provider
        self.actions = actions
    }
}

public protocol TextFieldEntryTableProvider: class {
    func getTextFieldEntryText(forIdentifier identifier: Any) -> String?
}

public protocol TextFieldEntryTableActions: class {
    func onTextFieldEntryChanged(text: String, forIdentifier identifier: Any)
}
