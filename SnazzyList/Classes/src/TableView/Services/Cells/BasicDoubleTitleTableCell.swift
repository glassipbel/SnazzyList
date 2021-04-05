//
//  BasicDoubleTitleTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 9/2/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a normal text side by side for the user.
/// The font can be defined and you can even add a callback for action if needed.
final class BasicDoubleTitleTableCell: UITableViewCell {
    let leftTitleLabel = UILabel(font: .systemFont(ofSize: 17.0, weight: .medium), textColor: .gray, textAlignment: .left)
    let rightTitleLabel = UILabel(font: .systemFont(ofSize: 17.0, weight: .medium), textColor: .gray, textAlignment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var leftTitleLeftConstraint: NSLayoutConstraint?
    private var rightTitleRightConstraint: NSLayoutConstraint?
    private var leftTitleTopConstraint: NSLayoutConstraint?
    private var leftTitleBottomConstraint: NSLayoutConstraint?
    
    private var configFile: BasicDoubleTitleTableCellConfigFile?
}

extension BasicDoubleTitleTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        configFile.actions?.onBasicDoubleTitleTapCell(withIdentifier: configFile.identifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BasicDoubleTitleTableCellConfigFile else { return }
        self.configFile = configFile
        
        leftTitleTopConstraint?.constant = configFile.topMargin
        leftTitleLeftConstraint?.constant = configFile.leftMargin
        rightTitleRightConstraint?.constant = configFile.rightMargin
        leftTitleBottomConstraint?.constant = configFile.bottomMargin
        contentView.backgroundColor = configFile.backgroundColor
        leftTitleLabel.font = configFile.leftFont
        leftTitleLabel.text = configFile.leftTitle
        leftTitleLabel.textColor = configFile.leftTitleColor
        rightTitleLabel.font = configFile.rightFont
        rightTitleLabel.text = configFile.rightTitle
        rightTitleLabel.textColor = configFile.rightTitleColor
        
        layoutIfNeeded()
    }
}

extension BasicDoubleTitleTableCell {
    private func setupViews() {
        setupBackground()
        setupLeftTitleLabel()
        setupRightTitleLabel()
    }
    
    private func setupLeftTitleLabel() {
        contentView.addSubview(leftTitleLabel)
    }
    
    private func setupRightTitleLabel() {
        rightTitleLabel.setContentHuggingPriority(UILayoutPriority.max, for: .horizontal)
        rightTitleLabel.setContentCompressionResistancePriority(UILayoutPriority.max, for: .horizontal)
        contentView.addSubview(rightTitleLabel)
    }
    
    private func setupConstraints() {
        leftTitleLeftConstraint = leftTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0.0)
        leftTitleLeftConstraint?.isActive = true
        leftTitleTopConstraint = leftTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0)
        leftTitleTopConstraint?.isActive = true
        leftTitleBottomConstraint = contentView.bottomAnchor.constraint(equalTo: leftTitleLabel.bottomAnchor, constant: 8.0)
        leftTitleBottomConstraint?.isActive = true
        leftTitleLabel.rightAnchor.constraint(equalTo: rightTitleLabel.leftAnchor, constant: -4.0).isActive = true
        
        rightTitleLabel.topAnchor.constraint(equalTo: leftTitleLabel.topAnchor).isActive = true
        rightTitleLabel.bottomAnchor.constraint(equalTo: leftTitleLabel.bottomAnchor).isActive = true
        rightTitleRightConstraint = contentView.rightAnchor.constraint(equalTo: rightTitleLabel.rightAnchor, constant: 0.0)
        rightTitleRightConstraint?.isActive = true
    }
}

struct BasicDoubleTitleTableCellConfigFile {
    let identifier: Any
    let leftTitle: String
    let leftFont: UIFont
    let leftTitleColor: UIColor
    let rightTitle: String
    let rightFont: UIFont
    let rightTitleColor: UIColor
    let backgroundColor: UIColor
    let leftMargin: CGFloat
    let rightMargin: CGFloat
    let topMargin: CGFloat
    let bottomMargin: CGFloat
    
    weak var actions: BasicDoubleTitleTableCellActions?
    
    init(identifier: Any, leftTitle: String, leftFont: UIFont, leftTitleColor: UIColor, rightTitle: String, rightFont: UIFont, rightTitleColor: UIColor, backgroundColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat, topMargin: CGFloat, bottomMargin: CGFloat, actions: BasicDoubleTitleTableCellActions?) {
        self.identifier = identifier
        self.leftTitle = leftTitle
        self.leftFont = leftFont
        self.leftTitleColor = leftTitleColor
        self.rightTitle = rightTitle
        self.rightFont = rightFont
        self.rightTitleColor = rightTitleColor
        self.backgroundColor = backgroundColor
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        self.actions = actions
    }
}

public protocol BasicDoubleTitleTableCellActions: class {
    func onBasicDoubleTitleTapCell(withIdentifier identifier: Any)
}
