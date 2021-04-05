//
//  BasicCheckTableCell.swift
//  Dms
//
//  Created by Kevin on 9/28/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show a check with text.
/// The behavior of this cell is hardcoded, and what i mean by that, the font wont change depending on it's selection, if this doesn't fit your needs, then you should check out the BasicCheckTableCell.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicCheckAlternativeTableCell.png?raw=true
final class BasicCheckAlternativeTableCell: UITableViewCell {
    let checkImageView = UIImageView(image: UIImage(named: "checkbox_off_alternative", in: Bundle.resourceBundle(for: BasicCheckAlternativeTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
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
    
    private var configFile: BasicCheckAlternativeTableCellConfigFile?
}

extension BasicCheckAlternativeTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BasicCheckAlternativeTableCellConfigFile else { return }
        self.configFile = configFile
        
        configureCheckbox()
        titleLabel.font = configFile.font
        titleLabel.attributedText = nil
        titleLabel.text = configFile.title
        titleLabel.textColor = configFile.textColor
        if let spacing = configFile.textCustomSpacing {
            titleLabel.addNormalLineSpacing(lineSpacing: spacing)
        }
        scrimView.isHidden = configFile.isEditable
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        guard configFile.isEditable else { return }
        UISelectionFeedbackGenerator().selectionChanged()
        configFile.actions?.tapOnCheckAlternative(forIdentifier: configFile.identifier)
        configureCheckbox()
    }
}

extension BasicCheckAlternativeTableCell {
    private func configureCheckbox() {
        guard let configFile = self.configFile else { return }
        
        let checked = configFile.provider?.getCheckAlternativeIsChecked(forIdentifier: configFile.identifier) ?? false
        
        if checked {
            checkImageView.image = configFile.checkedIcon ?? UIImage(named: "checkbox_on_alternative", in: Bundle.resourceBundle(for: BasicCheckAlternativeTableCell.self), compatibleWith: nil)
        } else {
            checkImageView.image = configFile.uncheckedIcon ?? UIImage(named: "checkbox_off_alternative", in: Bundle.resourceBundle(for: BasicCheckAlternativeTableCell.self), compatibleWith: nil)
        }
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
        
        checkImageView.assignSize(width: 14, height: 14)
        checkImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 3.0).isActive = true
        checkImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18.0).isActive = true
        checkImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4.0).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: checkImageView.rightAnchor, constant: 16.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -16.0).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4.0).isActive = true
    }
}

struct BasicCheckAlternativeTableCellConfigFile {
    let identifier: Any
    let isEditable: Bool
    let title: String
    let font: UIFont
    let textColor: UIColor
    let textCustomSpacing: CGFloat?
    let checkedIcon: UIImage?
    let uncheckedIcon: UIImage?
    
    weak var provider: BasicCheckAlternativeTableCellProvider?
    weak var actions: BasicCheckAlternativeTableCellActions?
    
    init(identifier: Any, title: String, font: UIFont, textColor: UIColor, textCustomSpacing: CGFloat?, isEditable: Bool, checkedIcon: UIImage?, uncheckedIcon: UIImage?, provider: BasicCheckAlternativeTableCellProvider?, actions: BasicCheckAlternativeTableCellActions?) {
        self.identifier = identifier
        self.title = title
        self.isEditable = isEditable
        self.font = font
        self.textColor = textColor
        self.textCustomSpacing = textCustomSpacing
        self.checkedIcon = checkedIcon
        self.uncheckedIcon = uncheckedIcon
        self.provider = provider
        self.actions = actions
    }
}

public protocol BasicCheckAlternativeTableCellProvider: class {
    func getCheckAlternativeIsChecked(forIdentifier identifier: Any) -> Bool
}

public protocol BasicCheckAlternativeTableCellActions: class {
    func tapOnCheckAlternative(forIdentifier identifier: Any)
}
