//
//  BorderedButtonDisclosureTableCell.swift
//  Noteworth2
//
//  Created by Olga Matsyk on 12/16/19.
//  Copyright © 2019 Noteworth. All rights reserved.
//

final class BorderedButtonDisclosureTableCell: UITableViewCell {
    private let fakeContainerView = UIView(backgroundColor: .white)
    private let disclosureImageView = UIImageView(image: UIImage(named: "right_arrow", in: Bundle.resourceBundle(for: BorderedButtonDisclosureTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    private let titleLabel = UILabel(font: .systemFont(ofSize: 16.0, weight: .regular), textColor: .black, textAlignment: .left)
    lazy var disclosureButton: UIButton = {
        return UIButton.getInvisible(target: self, action: #selector(tapDisclosureButton))
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       
       setupViews()
       setupConstraints()
    }
   
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapDisclosureButton() {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.tapBorderedButtonDisclosure(withIdentifier: configFile.identifier)
    }
   
    private var configFile: BorderedButtonDisclosureTableCellConfigFile?
}

extension BorderedButtonDisclosureTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? BorderedButtonDisclosureTableCellConfigFile else { return }
        self.configFile = configFile
        
        titleLabel.text = configFile.title
        titleLabel.font = configFile.titleFont
        titleLabel.textColor = configFile.titleColor
        
        fakeContainerView.layer.borderColor = configFile.containerColor.cgColor
        disclosureImageView.image = configFile.disclosureImage ?? UIImage(named: "right_arrow", in: Bundle.resourceBundle(for: BorderedButtonDisclosureTableCell.self), compatibleWith: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        configFile.actions?.tapBorderedButtonDisclosure(withIdentifier: configFile.identifier)
    }
}

private extension BorderedButtonDisclosureTableCell {
    private func setupViews() {
        setupBackground(backgroundColor: .clear)
        setupFakeBackground()
        setupDisclosureImageView()
        setupDisclosureButton()
        setupTitleLabel()
    }
    
    private func setupFakeBackground() {
        fakeContainerView.layer.cornerRadius = 4.0
        fakeContainerView.layer.borderWidth = 1.0
        contentView.addSubview(fakeContainerView)
    }
    
    private func setupDisclosureImageView() {
        fakeContainerView.addSubview(disclosureImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        fakeContainerView.addSubview(titleLabel)
    }
    
    private func setupDisclosureButton() {
        fakeContainerView.addSubview(disclosureButton)
    }
    
    private func setupConstraints() {
        fakeContainerView.bind(withConstant: 0.0, boundType: .vertical)
        fakeContainerView.bind(withConstant: 16.0, boundType: .horizontal)
        
        titleLabel.bind(withConstant: 20.0, boundType: .vertical)
        titleLabel.leftAnchor.constraint(equalTo: fakeContainerView.leftAnchor,  constant: 16.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: disclosureButton.leftAnchor).isActive = true
        titleLabel.setContentHuggingPriority(.max, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.max, for: .vertical)
        
        disclosureImageView.assignSize(width: 16.0, height: 16.0)
        disclosureImageView.rightAnchor.constraint(equalTo: fakeContainerView.rightAnchor, constant: -16.0).isActive = true
        disclosureImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

        disclosureButton.assignSize(width: 48.0, height: 64.0)
        disclosureButton.rightAnchor.constraint(equalTo: fakeContainerView.rightAnchor).isActive = true
        disclosureButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    }
}

struct BorderedButtonDisclosureTableCellConfigFile {
    let identifier: Any
    let title: String
    let titleFont: UIFont
    let titleColor: UIColor
    let containerColor: UIColor
    let disclosureImage: UIImage?
    
    weak var actions: BorderedButtonDisclosureTableCellActions?
    
    init(identifier: Any, title: String, titleFont: UIFont, titleColor: UIColor, containerColor: UIColor, disclosureImage: UIImage?, actions: BorderedButtonDisclosureTableCellActions?) {
        self.identifier = identifier
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.containerColor = containerColor
        self.disclosureImage = disclosureImage
        
        self.actions = actions
    }
}

public protocol BorderedButtonDisclosureTableCellActions: class {
    func tapBorderedButtonDisclosure(withIdentifier identifier: Any)
}
