//
//  DocumentationRepresentationTableCell.swift
//  Dms
//
//  Created by Kevin on 9/26/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show a document like style for your user to sign.
/// The behavior may be a constraint, so just confirm with the PM that this is the behavior that they want to be sure.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/DocumentationRepresentationTableCell.png?raw=true
final class DocumentationRepresentationTableCell: UITableViewCell {
    let containerView = UIView(backgroundColor: .white)
    let blueDetailView = UIView(backgroundColor: .blue)
    let documentIconImageView = UIImageView(image: UIImage(named: "document_small", in: Bundle.resourceBundle(for: DocumentationRepresentationTableCell.self), compatibleWith: nil), contentMode: .scaleAspectFit)
    let documentTitleLabel = UILabel(font: .systemFont(ofSize: 10.0, weight: .medium), textColor: .blue, textAlignment: .left)
    let documentDescriptionLabel = UILabel(font: .systemFont(ofSize: 14.0, weight: .regular), textColor: .black, textAlignment: .left)
    let reviewLabel = UILabel(font: .systemFont(ofSize: 14.0, weight: .bold), textColor: .blue, textAlignment: .center)
    let shadowView = UIView(backgroundColor: .white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: DocumentationRepresentationTableCellConfigFile?
}

extension DocumentationRepresentationTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? DocumentationRepresentationTableCellConfigFile else { return }
        self.configFile = configFile
        
        let isSigned = configFile.provider?.getDocumentIsSigned(withIdentifier: configFile.documentIdentifier) == true
        documentTitleLabel.text = isSigned ? configFile.signedTitleText.uppercased() : configFile.notSignedTitleText.uppercased()
        documentTitleLabel.textColor = isSigned ? configFile.signedTitleColor : configFile.notSignedTitleColor
        documentTitleLabel.font = configFile.titleFont
        blueDetailView.backgroundColor = isSigned ? configFile.signedBackgroundColor : configFile.notSignedBackgroundColor
        reviewLabel.text = isSigned ? configFile.signedReviewText.uppercased() : configFile.notSignedReviewText.uppercased()
        reviewLabel.textColor = configFile.reviewColor
        reviewLabel.font = configFile.reviewFont
        if isSigned {
            documentIconImageView.image = configFile.signedDocumentImage ?? UIImage(named: "checkmark_blue_small", in: Bundle.resourceBundle(for: DocumentationRepresentationTableCell.self), compatibleWith: nil)
        } else {
            documentIconImageView.image = configFile.notSignedDocumentImage ?? UIImage(named: "document_small", in: Bundle.resourceBundle(for: DocumentationRepresentationTableCell.self), compatibleWith: nil)
        }
        documentDescriptionLabel.text = configFile.provider?.getDocumentDescription(withIdentifier: configFile.documentIdentifier)
        documentDescriptionLabel.textColor = configFile.descriptionColor
        documentDescriptionLabel.font = configFile.descriptionFont
        documentDescriptionLabel.addNormalLineSpacing(lineSpacing: 4.0)
        
        
        shadowView.layer.shadowColor = configFile.shadowColor.cgColor
        containerView.layer.borderColor = configFile.containerBorderColor.cgColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.tapDocument(withIdentifier: configFile.documentIdentifier)
    }
}

extension DocumentationRepresentationTableCell {
    private func setupViews() {
        setupBackground()
        setupShadowView()
        setupContainerView()
        setupBlueDetailView()
        setupDocumentIconImageView()
        setupDocumentTitleLabel()
        setupDocumentDescriptionLabel()
        setupReviewLabel()
    }
    
    private func setupShadowView() {
        shadowView.layer.cornerRadius = 5.0
        shadowView.layer.shadowRadius = 3.0
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        contentView.addSubview(shadowView)
    }
    
    private func setupContainerView() {
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 5.0
        contentView.addSubview(containerView)
    }
    
    private func setupBlueDetailView() {
        containerView.addSubview(blueDetailView)
    }
    
    private func setupDocumentIconImageView() {
        containerView.addSubview(documentIconImageView)
    }
    
    private func setupDocumentTitleLabel() {
        containerView.addSubview(documentTitleLabel)
    }
    
    private func setupDocumentDescriptionLabel() {
        documentDescriptionLabel.numberOfLines = 2
        containerView.addSubview(documentDescriptionLabel)
    }
    
    private func setupReviewLabel() {
        containerView.addSubview(reviewLabel)
    }
    
    private func setupConstraints() {
        shadowView.matchEdges(to: containerView, horizontalConstants: -1.0)
        
        containerView.bind(withConstant: 16.0, boundType: .horizontal)
        containerView.bind(withConstant: 10.0, boundType: .vertical)
        
        blueDetailView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        blueDetailView.bind(withConstant: 0.0, boundType: .horizontal)
        blueDetailView.assignSize(height: 4.0)
        
        documentIconImageView.assignSize(width: 14.0, height: 14.0)
        documentIconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0).isActive = true
        documentIconImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12.0).isActive = true
        
        documentTitleLabel.centerYAnchor.constraint(equalTo: documentIconImageView.centerYAnchor).isActive = true
        documentTitleLabel.leftAnchor.constraint(equalTo: documentIconImageView.rightAnchor, constant: 8.0).isActive = true
        documentTitleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24.0).isActive = true
        
        documentDescriptionLabel.topAnchor.constraint(equalTo: documentIconImageView.bottomAnchor, constant: 16.0).isActive = true
        documentDescriptionLabel.bind(withConstant: 12.0, boundType: .horizontal)
        documentDescriptionLabel.bottomAnchor.constraint(equalTo: reviewLabel.topAnchor, constant: -16.0).isActive = true
        
        reviewLabel.setContentHuggingPriority(UILayoutPriority.max, for: .vertical)
        reviewLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0).isActive = true
    }
}

struct DocumentationRepresentationTableCellConfigFile {
    let documentIdentifier: String
    let signedTitleText: String
    let notSignedTitleText: String
    let signedReviewText: String
    let notSignedReviewText: String
    let signedTitleColor: UIColor
    let notSignedTitleColor: UIColor
    let signedBackgroundColor: UIColor
    let notSignedBackgroundColor: UIColor
    let descriptionColor: UIColor
    let reviewColor: UIColor
    let containerBorderColor: UIColor
    let shadowColor: UIColor
    let titleFont: UIFont
    let descriptionFont: UIFont
    let reviewFont: UIFont
    let signedDocumentImage: UIImage?
    let notSignedDocumentImage: UIImage?
    
    weak var provider: DocumentationRepresentationTableProvider?
    weak var actions: DocumentationRepresentationTableActions?
    
    init(documentIdentifier: String, signedTitleText: String, notSignedTitleText: String, signedReviewText: String, notSignedReviewText: String, signedTitleColor: UIColor, notSignedTitleColor: UIColor, signedBackgroundColor: UIColor, notSignedBackgroundColor: UIColor, descriptionColor: UIColor, reviewColor: UIColor, containerBorderColor: UIColor, shadowColor: UIColor, titleFont: UIFont, descriptionFont: UIFont, reviewFont: UIFont, signedDocumentImage: UIImage?, notSignedDocumentImage: UIImage?, provider: DocumentationRepresentationTableProvider?, actions: DocumentationRepresentationTableActions?) {
        self.documentIdentifier = documentIdentifier
        self.signedTitleText = signedTitleText
        self.notSignedTitleText = notSignedTitleText
        self.signedReviewText = signedReviewText
        self.notSignedReviewText = notSignedReviewText
        self.signedTitleColor = signedTitleColor
        self.notSignedTitleColor = notSignedTitleColor
        self.signedBackgroundColor = signedBackgroundColor
        self.notSignedBackgroundColor = notSignedBackgroundColor
        self.descriptionColor = descriptionColor
        self.reviewColor = reviewColor
        self.containerBorderColor = containerBorderColor
        self.shadowColor = shadowColor
        self.signedDocumentImage = signedDocumentImage
        self.notSignedDocumentImage = notSignedDocumentImage
        self.titleFont = titleFont
        self.descriptionFont = descriptionFont
        self.reviewFont = reviewFont
        self.provider = provider
        self.actions = actions
    }
}

public protocol DocumentationRepresentationTableProvider: class {
    func getDocumentDescription(withIdentifier identifier: String) -> String?
    func getDocumentIsSigned(withIdentifier identifier: String) -> Bool?
}

public protocol DocumentationRepresentationTableActions: class {
    func tapDocument(withIdentifier identifier: String)
}
