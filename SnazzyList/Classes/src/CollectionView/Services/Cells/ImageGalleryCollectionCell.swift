//
//  ImageGalleryCollectionCell.swift
//  Dms
//
//  Created by Kevin on 10/29/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show an image.
/// The size must be define outside the cell, and the image will use that specific size.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/CollectionView%20Shared%20Cells/ImageGalleryCollectionCell.png?raw=true
final class ImageGalleryCollectionCell: UICollectionViewCell {
    let mainImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var configFile: ImageGalleryCollectionCellConfigFile?
}

extension ImageGalleryCollectionCell: GenericCollectionCellProtocol {
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? ImageGalleryCollectionCellConfigFile else { return }
        self.configFile = configFile
        
        mainImageView.contentMode = configFile.contentMode
        DispatchQueue.main.async { [weak self] in
            self?.mainImageView.image = configFile.image
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let configFile = self.configFile else { return }
        
        configFile.actions?.tapGalleryImage(image: configFile.image)
    }
}

private extension ImageGalleryCollectionCell {
    private func setupViews() {
        setupBackground()
        setupMainImageView()
    }
    
    private func setupMainImageView() {
        contentView.addSubview(mainImageView)
    }
    
    private func setupConstraints() {
        mainImageView.bind(withConstant: 0.0, boundType: .full)
    }
}

struct ImageGalleryCollectionCellConfigFile {
    var image: UIImage
    let contentMode: UIView.ContentMode
    
    weak var actions: ImageGalleryTableActions?
    
    init(image: UIImage, contentMode: UIView.ContentMode, actions: ImageGalleryTableActions?) {
        self.image = image
        self.contentMode = contentMode
        self.actions = actions
    }
}


public protocol ImageGalleryTableActions: class {
    func tapGalleryImage(image: UIImage)
}
