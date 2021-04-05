//
//  BorderedTextTableCell.swift
//  Noteworth2
//
//  Created by Olga Matsyk on 1/8/20.
//  Copyright © 2020 Noteworth. All rights reserved.
//

/// This cell will fit cases were you need to show multiline bordered text with custom left right margins and configurable text attributes
final class BorderedTextTableCell: UITableViewCell {
    private let fakeContainerView = UIView(backgroundColor: .white)
    private let titleLabel = UILabel(font: .systemFont(ofSize: 12.0, weight: .regular), textColor: .black, textAlignment: .justified)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          
          setupViews()
          setupConstraints()
       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
    private var fakeContainerViewLeftConstraint: NSLayoutConstraint?
    private var fakeContainerViewRightConstraint: NSLayoutConstraint?
    private var configFile: BorderedTextTableCellConfigFile?
}

extension BorderedTextTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BorderedTextTableCellConfigFile else { return }
        self.configFile = configFile
        
        titleLabel.text = configFile.title
        titleLabel.font = configFile.font
        titleLabel.textColor = configFile.titleColor
        titleLabel.textAlignment = configFile.textAlignment
        if let customLineSpacing = configFile.customLineSpacing {
            titleLabel.addNormalLineSpacing(lineSpacing: customLineSpacing)
        }
        fakeContainerView.backgroundColor = configFile.containerBackgroundColor
        fakeContainerView.layer.backgroundColor = configFile.containerBackgroundColor.cgColor
        fakeContainerViewLeftConstraint?.constant = configFile.leftMargin
        fakeContainerViewRightConstraint?.constant = configFile.rightMargin * -1
        fakeContainerView.layer.borderColor = configFile.containerBorderColor.cgColor
        contentView.backgroundColor = configFile.backgroundColor
        contentView.layoutIfNeeded()
    }
}

private extension BorderedTextTableCell {
    private func setupViews() {
        setupBackground(backgroundColor: .white)
        setupFakeBackground()
        setupTitleLabel()
    }
    
    private func setupFakeBackground() {
        fakeContainerView.layer.cornerRadius = 4.0
        fakeContainerView.layer.borderWidth = 2.0
        contentView.addSubview(fakeContainerView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        fakeContainerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        fakeContainerView.bind(withConstant: 0.0, boundType: .vertical)

        fakeContainerViewLeftConstraint = fakeContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        fakeContainerViewLeftConstraint?.isActive = true
        
        fakeContainerViewRightConstraint = fakeContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        fakeContainerViewRightConstraint?.isActive = true
        
        titleLabel.bind(withConstant: 8.0, boundType: .vertical)
        titleLabel.bind(withConstant: 8.0, boundType: .horizontal)
    }
}

struct BorderedTextTableCellConfigFile {
    let title: String
    let font: UIFont
    let titleColor: UIColor
    let textAlignment: NSTextAlignment
    let backgroundColor: UIColor
    let containerBackgroundColor: UIColor
    let containerBorderColor: UIColor
    let leftMargin: CGFloat
    let rightMargin: CGFloat
    let customLineSpacing: CGFloat?
    
    init(title: String, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment, backgroundColor: UIColor, containerBackgroundColor: UIColor, containerBorderColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat, customLineSpacing: CGFloat?) {
        self.title = title
        self.font = font
        self.titleColor = titleColor
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        self.containerBackgroundColor = containerBackgroundColor
        self.containerBorderColor = containerBorderColor
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.customLineSpacing = customLineSpacing
    }
}
