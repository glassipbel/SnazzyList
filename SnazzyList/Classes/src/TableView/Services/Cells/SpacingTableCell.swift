//
//  SpacingTableCell.swift
//  Dms
//
//  Created by Kevin on 9/25/18.
//  Copyright © 2018 DMS. All rights reserved.
//

import UIKit

/// This cell will fit the cases were you need to show or add spacings in the table view, or if you need to add lines for separations as well.
/// The size can be define for yours needs.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/SpacingTableCell.png?raw=true
final class SpacingTableCell: UITableViewCell, GenericTableCellProtocol {
    let lineView = UIView(backgroundColor: .clear)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? SpacingTableCellConfigFile else { return }
        
        lineView.backgroundColor = configFile.lineColor
        backgroundColor = configFile.backgroundColor
        contentView.backgroundColor = configFile.backgroundColor
        lineLeftConstraint?.constant = configFile.leftMargin
        lineRightConstraint?.constant = configFile.rightMargin * -1
        contentView.layoutIfNeeded()
    }
    
    private var lineLeftConstraint: NSLayoutConstraint?
    private var lineRightConstraint: NSLayoutConstraint?
}

extension SpacingTableCell {
    private func setupViews() {
        setupBackground()
        contentView.addSubview(lineView)
    }
    
    private func setupConstraints() {
        lineView.bind(withConstant: 0.0, boundType: .vertical)
        lineLeftConstraint = lineView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        lineLeftConstraint?.isActive = true
        lineRightConstraint = lineView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        lineRightConstraint?.isActive = true
    }
}

struct SpacingTableCellConfigFile {
    let backgroundColor: UIColor
    let lineColor: UIColor
    let leftMargin: CGFloat
    let rightMargin: CGFloat
    
    init(lineColor: UIColor/* = .dmsCloudyBlueTwo*/, backgroundColor: UIColor/* = .white*/, leftMargin: CGFloat = 0.0, rightMargin: CGFloat = 0.0) {
        self.backgroundColor = backgroundColor
        self.lineColor = lineColor
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
    }
}
