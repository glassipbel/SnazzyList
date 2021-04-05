//
//  BasicTitleTableCell.swift
//  Dms
//
//  Created by Kevin on 10/31/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show a normal text for the user.
/// The font can be defined and you can even add a callback for action if needed.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicTitleTableCell.png?raw=true
final class BasicTitleTableCell: UITableViewCell {
    let titleLabel = UILabel(font: .systemFont(ofSize: 17.0, weight: .medium), textColor: .gray, textAlignment: .center)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var configFile: BasicTitleTableCellConfigFile?
}

extension BasicTitleTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.onBasicTitleTapCell(withIdentifier: configFile.identifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BasicTitleTableCellConfigFile else { return }
        self.configFile = configFile
        
        leftConstraint?.constant = configFile.leftMargin
        rightConstraint?.constant = configFile.rightMargin
        topConstraint?.constant = configFile.topMargin
        bottomConstraint?.constant = configFile.bottomMargin
        setupBackground(backgroundColor: configFile.backgroundColor)
        titleLabel.font = configFile.font
        titleLabel.textColor = configFile.titleColor
        titleLabel.textAlignment = configFile.textAlignment
        titleLabel.numberOfLines = configFile.numberOfLines
        if let attributedTitle = configFile.attributedTitle {
            titleLabel.attributedText = attributedTitle
        } else {
            titleLabel.text = configFile.title
        }
        if let lineSpacing = configFile.customLineSpacing {
            configFile.attributedTitle != nil ? titleLabel.addAttributedLineSpacing(lineSpacing: lineSpacing, textAlignment: configFile.textAlignment) : titleLabel.addNormalLineSpacing(lineSpacing: lineSpacing)
        }
        layoutIfNeeded()
    }
}

extension BasicTitleTableCell {
    private func setupViews() {
        setupBackground()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.max, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.max, for: .horizontal)
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        leftConstraint = titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0.0)
        leftConstraint?.isActive = true
        rightConstraint = contentView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0.0)
        rightConstraint?.isActive = true
        topConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0)
        topConstraint?.isActive = true
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0)
        bottomConstraint?.isActive = true
    }
}

struct BasicTitleTableCellConfigFile {
    let identifier: Any
    let title: String
    let attributedTitle: NSAttributedString?
    let font: UIFont
    let titleColor: UIColor
    let textAlignment: NSTextAlignment
    let backgroundColor: UIColor
    let leftMargin: CGFloat
    let rightMargin: CGFloat
    let numberOfLines: Int
    let customLineSpacing: CGFloat?
    let topMargin: CGFloat
    let bottomMargin: CGFloat
    
    weak var actions: BasicTitleTableCellActions?
    
    init(identifier: Any = "", title: String, attributedTitle: NSAttributedString?, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int, backgroundColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat, topMargin: CGFloat, bottomMargin: CGFloat, customLineSpacing: CGFloat?, actions: BasicTitleTableCellActions?) {
        self.identifier = identifier
        self.title = title
        self.attributedTitle = attributedTitle
        self.font = font
        self.titleColor = titleColor
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        self.numberOfLines = numberOfLines
        self.customLineSpacing = customLineSpacing
        self.actions = actions
    }
}

public protocol BasicTitleTableCellActions: class {
    func onBasicTitleTapCell(withIdentifier identifier: Any)
}
