//
//  CollectionViewSharedCellsController.swift
//  Dms
//
//  Created by Kevin on 10/29/18.
//  Copyright © 2018 DMS. All rights reserved.
//

final public class SLCollectionViewSharedCellsController {
    public init() {}
    
    /// This cell will fit the cases were you need to show an image.
    /// The size must be define outside the cell, and the image will use that specific size.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/CollectionView%20Shared%20Cells/ImageGalleryCollectionCell.png?raw=true
    public func getImageGalleryCollectionCellConfigFile(image: UIImage, contentMode: UIView.ContentMode, actions: ImageGalleryTableActions?, section: Int, height: CGFloat, width: CGFloat) -> GenericCollectionCellConfigurator {
        let item = ImageGalleryCollectionCellConfigFile(image: image, contentMode: contentMode, actions: actions)
        
        return GenericCollectionCellConfigurator(classType: ImageGalleryCollectionCell.self, item: item, section: section, sizingType: .specificSize(CGSize(width: width, height: height)))
    }
}
