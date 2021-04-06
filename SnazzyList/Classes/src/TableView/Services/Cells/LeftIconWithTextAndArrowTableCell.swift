//
//  LeftIconWithTextAndArrowTableCell.swift
//  Noteworth2
//
//  Created by Kevin on 2/19/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

/// This cell will fit the cases were you need to show a cell with an icon, text and a detail arrow like in the screenshot.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/LeftIconWithTextAndArrowTableCell.png?raw=true
final class LeftIconWithTextAndArrowTableCell: UITableViewCell {
    private let leftIconImageView = UIImageView(image: nil, contentMode: .scaleAspectFit)
    private let titleLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .regular), textColor: .black, textAlignment: .left)
    private let rightArrowImageView = UIImageView(image: UIImage(named: "arrow_right_medium", in: Bundle.resourceBundle(for: LeftIconWithTextAndArrowTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: LeftIconWithTextAndArrowTableCellConfigFile?
}

extension LeftIconWithTextAndArrowTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? LeftIconWithTextAndArrowTableCellConfigFile else { return }
        self.configFile = configFile
        
        titleLabel.text = configFile.title
        titleLabel.font = configFile.titleFont
        titleLabel.textColor = configFile.titleColor
        titleLabel.addNormalLineSpacing(lineSpacing: 4.0)
        
        leftIconImageView.image = configFile.icon
        rightArrowImageView.image = configFile.arrowImage ?? UIImage(named: "arrow_right_medium", in: Bundle.resourceBundle(for: LeftIconWithTextAndArrowTableCell.self), compatibleWith: nil)
        setupBackground(backgroundColor: configFile.backgroundColor)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        configFile.actions?.tapOnLeftIconWithText(withIdentifier: configFile.identifier)
    }
}

private extension LeftIconWithTextAndArrowTableCell {
    private func setupViews() {
        setupBackground()
        setupLeftIconImageView()
        setupTitleLabel()
        setupRightArrowImageView()
    }
    
    private func setupLeftIconImageView() {
        contentView.addSubview(leftIconImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    private func setupRightArrowImageView() {
        contentView.addSubview(rightArrowImageView)
    }
    
    private func setupConstraints() {
        leftIconImageView.assignSize(width: 24.0, height: 24.0)
        leftIconImageView.bind(withConstant: 28.0, boundType: .vertical)
        leftIconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: leftIconImageView.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftIconImageView.rightAnchor, constant: 12.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightArrowImageView.leftAnchor, constant: -8.0).isActive = true
        
        rightArrowImageView.assignSize(width: 16.0, height: 16.0)
        rightArrowImageView.centerYAnchor.constraint(equalTo: leftIconImageView.centerYAnchor).isActive = true
        rightArrowImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
    }
}

struct LeftIconWithTextAndArrowTableCellConfigFile {
    let identifier: Any
    let title: String
    let icon: UIImage
    let backgroundColor: UIColor
    let titleFont: UIFont
    let titleColor: UIColor
    let arrowImage: UIImage?
    
    weak var actions: LeftIconWithTextAndArrowTableCellActions?
    
    init(identifier: Any, title: String, icon: UIImage, backgroundColor: UIColor, titleFont: UIFont, titleColor: UIColor, arrowImage: UIImage?, actions: LeftIconWithTextAndArrowTableCellActions?) {
        self.identifier = identifier
        self.title = title
        self.icon = icon
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.arrowImage = arrowImage
        self.backgroundColor = backgroundColor
        
        self.actions = actions
    }
}

public protocol LeftIconWithTextAndArrowTableCellActions: class {
    func tapOnLeftIconWithText(withIdentifier identifier: Any)
}
