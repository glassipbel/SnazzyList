//
//  DropdownOptionSelectionTableCell.swift
//  Dms
//
//  Created by Kevin on 9/24/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show a dropdown, the dropdown can be full screen or partial screen depending on the title.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/DropdownOptionSelectionTableCell.png?raw=true
final class DropdownOptionSelectionTableCell: UITableViewCell {
    let containerView = UIView(backgroundColor: .white)
    let titleLabel = UILabel(font: .systemFont(ofSize: 12.0, weight: .medium), textColor: .blue, textAlignment: .left)
    let optionNameLabel = UILabel(font: .systemFont(ofSize: 17.0, weight: .medium), textColor: .blue, textAlignment: .left)
    let arrowDownImageView = UIImageView(image: UIImage(named: "down_arrow_selection", in: Bundle.resourceBundle(for: DropdownOptionSelectionTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    let titleLineView = UIView(backgroundColor: .blue)
    let scrimView = UIView(backgroundColor: UIColor.white.withAlphaComponent(0.6))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var containerViewRightAnchor: NSLayoutConstraint?
    private var configFile: DropdownOptionSelectionTableCellConfigFile?
}

extension DropdownOptionSelectionTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? DropdownOptionSelectionTableCellConfigFile else { return }
        
        self.configFile = configFile
        
        if let title = configFile.provider?.getSelectedDropdownOptionValue(forIdentifier: configFile.identifier) {
            optionNameLabel.text = title
            optionNameLabel.textColor = configFile.optionColor
            optionNameLabel.font = configFile.optionFont
            titleLabel.isHidden = false
        } else {
            optionNameLabel.text = configFile.title
            optionNameLabel.textColor = configFile.optionColor
            optionNameLabel.font = configFile.optionFont
            titleLabel.isHidden = true
        }
        
        titleLabel.text = configFile.title
        titleLabel.textColor = configFile.titleColor
        titleLabel.font = configFile.titleFont
        
        scrimView.isHidden = configFile.isEditable
        
        // TODO: check if it is the best way for add image if it is not null
        if let downArrowImage = configFile.downArrowImage {
            arrowDownImageView.image = downArrowImage
        }
        self.containerViewRightAnchor?.isActive = !configFile.adjustableToTitle
        self.contentView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile, configFile.isEditable else { return }
        configFile.actions?.tapDropdownOptionSelection(withIdentifier: configFile.identifier)
    }
}

extension DropdownOptionSelectionTableCell {
    private func setupViews() {
        setupBackground()
        setupContainerView()
        setupTitleLabel()
        setupOptionNameLabel()
        setupArrowDownImageView()
        setupTitleLineView()
        setupScrimView()
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
    }
    
    private func setupScrimView() {
        containerView.addSubview(scrimView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        containerView.addSubview(titleLabel)
    }
    
    private func setupOptionNameLabel() {
        optionNameLabel.numberOfLines = 1
        containerView.addSubview(optionNameLabel)
    }
    
    private func setupArrowDownImageView() {
        containerView.addSubview(arrowDownImageView)
    }
    
    private func setupTitleLineView() {
        containerView.addSubview(titleLineView)
    }
    
    private func setupConstraints() {
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        containerViewRightAnchor = contentView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 16.0)
        containerViewRightAnchor?.isActive = true
        containerView.bind(withConstant: 0.0, boundType: .vertical)
        
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: arrowDownImageView.leftAnchor, constant: -10.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0).isActive = true
        
        optionNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0).isActive = true
        optionNameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        optionNameLabel.rightAnchor.constraint(lessThanOrEqualTo: arrowDownImageView.leftAnchor, constant: -4.0).isActive = true
        optionNameLabel.assignSize(height: 26.0)
        
        arrowDownImageView.assignSize(width: 18.0, height: 18.0)

        arrowDownImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8.0).isActive = true
        arrowDownImageView.centerYAnchor.constraint(equalTo: optionNameLabel.centerYAnchor).isActive = true
        
        titleLineView.assignSize(height: 2.0)
        titleLineView.bind(withConstant: 0.0, boundType: .horizontal)
        titleLineView.topAnchor.constraint(equalTo: optionNameLabel.bottomAnchor, constant: 8.0).isActive = true
        
        scrimView.matchEdges(to: optionNameLabel)
    }
}

struct DropdownOptionSelectionTableCellConfigFile {
    let identifier: Any
    let title: String
    let titleColor: UIColor
    let titleFont: UIFont
    let optionColor: UIColor
    let optionFont: UIFont
    let downArrowImage: UIImage?
    let titleLineColor: UIColor
    let isEditable: Bool
    let adjustableToTitle: Bool
    
    weak var provider: DropdownOptionSelectionTableProvider?
    weak var actions: DropdownOptionSelectionTableActions?
    
    init(identifier: Any, title: String, titleColor: UIColor, titleFont: UIFont, optionColor: UIColor, optionFont: UIFont, downArrowImage: UIImage?, titleLineColor: UIColor, isEditable: Bool, adjustableToTitle: Bool, provider: DropdownOptionSelectionTableProvider?, actions: DropdownOptionSelectionTableActions?) {
        self.identifier = identifier
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.optionColor = optionColor
        self.optionFont = optionFont
        self.downArrowImage = downArrowImage
        self.titleLineColor = titleLineColor
        self.isEditable = isEditable
        self.adjustableToTitle = adjustableToTitle
        self.provider = provider
        self.actions = actions
    }
}

public protocol DropdownOptionSelectionTableProvider: class {
    func getSelectedDropdownOptionValue(forIdentifier identifier: Any) -> String?
}

public protocol DropdownOptionSelectionTableActions: class {
    func tapDropdownOptionSelection(withIdentifier identifier: Any)
}
