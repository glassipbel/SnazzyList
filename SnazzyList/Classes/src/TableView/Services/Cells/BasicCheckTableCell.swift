//
//  BasicCheckTableCell.swift
//  Dms
//
//  Created by Kevin on 9/28/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show a check with text.
/// The behavior of this cell is hardcoded, and what i mean by that, is that when it's selected the font will be bold and when is not, the font will be book, so if it does not fit your needs, then you shouldn't use this cell and you may be interested in BasicCheckAlternativeTableCell.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicCheckTableCell.png?raw=true
final class BasicCheckTableCell: UITableViewCell {
    let checkImageView = UIImageView(image: UIImage(named: "checkbox_off", in: Bundle.resourceBundle(for: BasicCheckTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    let titleLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .medium), textColor: .black, textAlignment: .left)
    let scrimView = UIView(backgroundColor: UIColor.white.withAlphaComponent(0.6))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: BasicCheckTableCellConfigFile?
}

extension BasicCheckTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BasicCheckTableCellConfigFile else { return }
        self.configFile = configFile
        
        configureCheckbox()
        configureTitle()
        scrimView.isHidden = configFile.isEditable
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        guard configFile.isEditable else { return }
        UISelectionFeedbackGenerator().selectionChanged()
        configFile.actions?.tapOnCheck(forIdentifier: configFile.identifier)
        configureCheckbox()
        configureTitle()
    }
}

extension BasicCheckTableCell {
    private func configureCheckbox() {
        guard let configFile = self.configFile else { return }
        
        let checked = configFile.provider?.getCheckIsChecked(forIdentifier: configFile.identifier) ?? false
        if checked {
            checkImageView.image = configFile.checkedIcon ?? UIImage(named: "checkbox_on", in: Bundle.resourceBundle(for: BasicCheckTableCell.self), compatibleWith: nil)
        } else {
            checkImageView.image = configFile.uncheckedIcon ?? UIImage(named: "checkbox_off", in: Bundle.resourceBundle(for: BasicCheckTableCell.self), compatibleWith: nil)
        }
    }
    
    private func configureTitle() {
        guard let configFile = self.configFile else { return }
        
        let checked = configFile.provider?.getCheckIsChecked(forIdentifier: configFile.identifier) ?? false
        let title = configFile.provider?.getCheckTitle(forIdentifier: configFile.identifier) ?? ""
        
        titleLabel.font = checked ? configFile.checkedTitleFont : configFile.uncheckedTitleFont
        titleLabel.textColor = configFile.titleColor
        titleLabel.text = title
        titleLabel.addNormalLineSpacing(lineSpacing: 4.0)
    }
    
    private func setupViews() {
        setupBackground()
        setupCheckImageView()
        setupTitleLabel()
        setupScrimView()
    }
    
    private func setupCheckImageView() {
        contentView.addSubview(checkImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    private func setupScrimView() {
        contentView.addSubview(scrimView)
    }
    
    private func setupConstraints() {
        scrimView.bind(withConstant: 0.0, boundType: .full)
        
        titleLabel.leftAnchor.constraint(equalTo: checkImageView.rightAnchor, constant: 8.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9.0).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: checkImageView.heightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9.0).isActive = true
        
        checkImageView.assignSize(width: 24, height: 24)
        checkImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        checkImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
    }
}

struct BasicCheckTableCellConfigFile {
    let identifier: Any
    let isEditable: Bool
    let checkedTitleFont: UIFont
    let uncheckedTitleFont: UIFont
    let checkedIcon: UIImage?
    let uncheckedIcon: UIImage?
    
    let titleColor: UIColor
    
    weak var provider: BasicCheckTableProvider?
    weak var actions: BasicCheckTableActions?
    
    init(identifier: Any, isEditable: Bool, checkedTitleFont: UIFont, uncheckedTitleFont: UIFont, titleColor: UIColor, checkedIcon: UIImage?, uncheckedIcon: UIImage?, provider: BasicCheckTableProvider?, actions: BasicCheckTableActions?) {
        self.identifier = identifier
        self.isEditable = isEditable
        self.checkedTitleFont = checkedTitleFont
        self.uncheckedTitleFont = uncheckedTitleFont
        self.checkedIcon = checkedIcon
        self.uncheckedIcon = uncheckedIcon
        self.titleColor = titleColor
        self.provider = provider
        self.actions = actions
    }
}

public protocol BasicCheckTableProvider: class {
    func getCheckIsChecked(forIdentifier identifier: Any) -> Bool
    func getCheckTitle(forIdentifier identifier: Any) -> String
}

public protocol BasicCheckTableActions: class {
    func tapOnCheck(forIdentifier identifier: Any)
}
