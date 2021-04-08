//
//  CollectionViewDemoViewController.swift
//  SnazzyList_Example
//
//  Created by Santiago Delgado on 8/04/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SnazzyList
import SnazzyAccessibility
import UIKit

class CollectionViewDemoViewController: UIViewController {

    private(set) var collectionView = UICollectionView.getDefault()
    
    private var datasource: GenericCollectionViewDataSource!
    private var delegate: GenericCollectionViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViewController()
    }

    func loadViewController() {
        setupViews()
        setupConstraints()
        setupDatasourceAndDelegate()
        showItems()
    }
    
    private func setupViews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.isScrollEnabled = false
        
        self.view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        let margins = view.layoutMarginsGuide
        
        collectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func setupDatasourceAndDelegate() {
        datasource = GenericCollectionViewDataSource(collectionView: collectionView, configFiles: [])
        delegate = GenericCollectionViewDelegate(dataSource: datasource, isSelfSizing: false)
    }
    
    func showItems() {
        var configFiles = [GenericCollectionCellConfigurator]()
        let controller = SLCollectionViewSharedCellsController()
        
        configFiles.append(controller.getImageGalleryCollectionCellConfigFile(image: #imageLiteral(resourceName: "demoImage"), contentMode: .scaleAspectFill, actions: nil, section: 0, height: 50.0, width: 50.0))
        
        datasource.configFiles = configFiles
        datasource.reload()
    }
}
