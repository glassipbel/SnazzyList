//
//  BasicCheckAlternativeSecondTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 9/3/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a check with text.
/// The behavior of this cell is hardcoded, and what i mean by that, the font wont change depending on it's selection, if this doesn't fit your needs, then you should check out the BasicCheckTableCell.
final class BasicCheckAlternativeSecondTableCell: UITableViewCell {
    let checkImageView = UIImageView(image: UIImage(named: "checkbox_circle_off", in: Bundle.resourceBundle(for: BasicCheckTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    let titleLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .medium), textColor: .black, textAlignment: .left)
    let containerView = UIView(backgroundColor: .white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: BasicCheckAlternativeSecondTableCellConfigFile?
}

extension BasicCheckAlternativeSecondTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BasicCheckAlternativeSecondTableCellConfigFile else { return }
        self.configFile = configFile
        
        configureSelection()
        titleLabel.text = configFile.title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        
        UISelectionFeedbackGenerator().selectionChanged()
        configFile.actions?.tapOnCheckAlternativeSecond(forIdentifier: configFile.identifier)
        configureSelection()
    }
}

extension BasicCheckAlternativeSecondTableCell {
    private func configureSelection() {
        guard let configFile = self.configFile else { return }
        
        titleLabel.textColor = configFile.titleColor
        let checked = configFile.provider?.getCheckAlternativeSecondIsChecked(forIdentifier: configFile.identifier) ?? false
        
        if checked {
            checkImageView.image = configFile.checkedIcon ?? UIImage(named: "checkbox_circle_on", in: Bundle.resourceBundle(for: BasicCheckTableCell.self), compatibleWith: nil)
            containerView.layer.borderColor = configFile.checkedBorderColor.cgColor
            titleLabel.font = configFile.checkedTitleFont
        } else {
            checkImageView.image = configFile.uncheckedIcon ?? UIImage(named: "checkbox_circle_off", in: Bundle.resourceBundle(for: BasicCheckTableCell.self), compatibleWith: nil)
            containerView.layer.borderColor = configFile.uncheckedBorderColor.cgColor
            titleLabel.font = configFile.uncheckedTitleFont
        }
    }
    
    private func setupViews() {
        setupBackground()
        setupContainerView()
        setupCheckImageView()
        setupTitleLabel()
    }
    
    private func setupContainerView() {
        containerView.layer.cornerRadius = 12.0
        containerView.layer.borderWidth = 2.0
        contentView.addSubview(containerView)
    }
    
    private func setupCheckImageView() {
        containerView.addSubview(checkImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        containerView.bind(withConstant: 12.0, boundType: .horizontal)
        containerView.bind(withConstant: 8.0, boundType: .vertical)
        containerView.assignSize(height: 44.0)
        
        checkImageView.assignSize(width: 16, height: 16)
        checkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        checkImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8.0).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: checkImageView.rightAnchor, constant: 8.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -4.0).isActive = true
    }
}

struct BasicCheckAlternativeSecondTableCellConfigFile {
    let identifier: String
    let title: String
    let titleColor: UIColor
    let checkedTitleFont: UIFont
    let uncheckedTitleFont: UIFont
    let checkedBorderColor: UIColor
    let uncheckedBorderColor: UIColor
    let checkedIcon: UIImage?
    let uncheckedIcon: UIImage?
    weak var provider: BasicCheckAlternativeSecondTableCellProvider?
    weak var actions: BasicCheckAlternativeSecondTableCellActions?
    
    init(identifier: String, title: String, titleColor: UIColor, checkedTitleFont: UIFont, uncheckedTitleFont: UIFont, checkedIcon: UIImage?, uncheckedIcon: UIImage?, checkedBorderColor: UIColor, uncheckedBorderColor: UIColor, provider: BasicCheckAlternativeSecondTableCellProvider?, actions: BasicCheckAlternativeSecondTableCellActions?) {
        self.identifier = identifier
        self.title = title
        self.titleColor = titleColor
        self.checkedTitleFont = checkedTitleFont
        self.uncheckedTitleFont = uncheckedTitleFont
        self.checkedBorderColor = checkedBorderColor
        self.uncheckedBorderColor = uncheckedBorderColor
        self.checkedIcon = checkedIcon
        self.uncheckedIcon = uncheckedIcon
        self.provider = provider
        self.actions = actions
    }
}

public protocol BasicCheckAlternativeSecondTableCellProvider: class {
    func getCheckAlternativeSecondIsChecked(forIdentifier identifier: String) -> Bool
}

public protocol BasicCheckAlternativeSecondTableCellActions: class {
    func tapOnCheckAlternativeSecond(forIdentifier identifier: String)
}
