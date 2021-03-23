//
//  CollectionView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public class GenericCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    public var configFiles: [GenericCollectionCellConfigurator] {
        didSet {
            registerCells()
        }
    }
    
    public init(collectionView: UICollectionView, configFiles: [GenericCollectionCellConfigurator]) {
        self.collectionView = collectionView
        self.configFiles = configFiles
        super.init()
        registerCells()
        self.collectionView.dataSource = self
    }
    
    // MARK: - Collection View Data Source Methods.
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let configFile = (configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell })[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: configFile.className, for: indexPath)
        cell.accessibilityIdentifier = "\(type(of: cell)).s\(indexPath.section)-i\(indexPath.item)"
        cell.isAccessibilityElement = false
        (cell as? GenericCollectionCellProtocol)?.collectionView(collectionView: collectionView, cellForItemAt: indexPath, with: configFile.item)
        
        var accessibilityInfo = configFile.accessibilityInfo
        accessibilityInfo?.indexPath = indexPath
        cell.setupAccessibilityIdentifiersForViewProperties(withAccessibilityInfo: accessibilityInfo)
        
        switch configFile.sizingType {
        case .automatic(let width):
            (cell as? CollectionViewSelfSizingCell)?.maxWidth = width
        case .fullRowAutomatic:
            (cell as? CollectionViewSelfSizingCell)?.maxWidth = self.collectionView.bounds.width
        default: break
        }
        
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let maxSectionNumber = (configFiles.map { $0.section }.sorted { $0 > $1 }).first else { return 1 }
        return maxSectionNumber + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        return items
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let typeCell = CollectionCellType.getCollectionCellTypeBySupplementaryKind(kind: kind)
            else { return UICollectionReusableView() }
        
        guard let configFile = (configFiles.filter { $0.typeCell == typeCell && $0.section == indexPath.section }).first
            else { return UICollectionReusableView() }
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: configFile.className,
            for: indexPath) as! GenericCollectionReusableProtocol
        
        reusableView.collectionView(
            collectionView: collectionView,
            viewForSupplementaryElementOfKind: kind,
            at: indexPath,
            with: configFile.item)
        
        (reusableView as? CollectionReusableSelfSizingView)?.maxWidth = collectionView.bounds.width
        
        return reusableView as! UICollectionReusableView
    }
    // ---
    
    weak var collectionView: UICollectionView!
}

extension GenericCollectionViewDataSource {
    // MARK: - Util Methods.
    public func getCell<T>(by filter: (GenericCollectionCellConfigurator)->Bool) -> T? {
        guard let indexPath = getIndexPath(by: filter) else { return nil }
        return self.collectionView.cellForItem(at: indexPath) as? T
    }
    
    public func getIndexPath(by filter: (GenericCollectionCellConfigurator)->Bool) -> IndexPath? {
        guard let configFile = configFiles.filter(filter).first else { return nil }
        
        let allRowsForSection = configFiles.filter { $0.section == configFile.section && $0.typeCell == .cell }
        
        guard let indexInSection = allRowsForSection.firstIndex(where: filter) else { return nil }
        
        return IndexPath(item: indexInSection, section: configFile.section)
    }
    
    public func update<T,U:UICollectionViewCell>(cellFinder filter: @escaping (GenericCollectionCellConfigurator)->Bool, updates: (T, U?) -> ()) {
        guard let item = configFiles.first(where: filter)?.item as? T else { return }
        guard let indexPath = getIndexPath(by: filter) else {
            updates(item, nil)
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as? U
        updates(item, cell)
    }
    
    public func reload() {
        collectionView.reloadData()
    }
    
    public func reloadAt(section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }
    
    public func reloadAtSections(indexSet: IndexSet) {
        collectionView.reloadSections(indexSet)
    }
    
    public func reloadAt(indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    public func reloadAt(indexPath: IndexPath) {
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - Delete Methods
    public func deleteRow(by filter: @escaping (GenericCollectionCellConfigurator)->Bool, completion: (()->())? = nil) {
        self.collectionView.performBatchUpdates({ 
            guard let indexPath = self.getIndexPath(by: filter) else { return }

            let numberOfSections = self.collectionView.numberOfSections
            self.configFiles = self.configFiles.filter { !filter($0) }
            let rowsWithHeaders = self.configFiles.filter { $0.section == indexPath.section }
            self.collectionView.deleteItems(at: [indexPath])
            
            if numberOfSections - 1 == indexPath.section && rowsWithHeaders.count == 0 && numberOfSections > 1 {
                self.collectionView.deleteSections(self.getIndexSetToDelete(forSection: indexPath.section))
            }
        }) { finish in
            if !finish { return }
            completion?()
        }
    }
    
    public func deleteAllRowsAt(section: Int, completion: (()->())? = nil) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
        if configFilesToDelete.count == 0 { completion?(); return }
        
        var indexPaths = [IndexPath]()
        for (index, _) in configFilesToDelete.enumerated() {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        collectionView.performBatchUpdates({
    
            self.collectionView.deleteItems(at: indexPaths)
            self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
            
            // Delete section if needed.
            let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
            if section == self.collectionView.numberOfSections - 1 &&
                self.collectionView.numberOfSections > 1 &&
                headersOrFootersInSection.count == 0 {
                self.collectionView.deleteSections(self.getIndexSetToDelete(forSection: section))
            }
            // ---
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    public func delete(at section: Int, andInsert configFiles: [GenericCollectionCellConfigurator], completion: (()->())? = nil) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
        var indexPaths = [IndexPath]()
        for (index, _) in configFilesToDelete.enumerated() {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        collectionView.performBatchUpdates({
            
            self.collectionView.deleteItems(at: indexPaths)
            self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
            
            // Delete section if needed.
            let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
            var maxSectionInsertedOpt: Int? = nil
            
            if section == self.collectionView.numberOfSections - 1 &&
                self.collectionView.numberOfSections > 1 &&
                headersOrFootersInSection.count == 0 {
                let indexSet = self.getIndexSetToDelete(forSection: section)
                self.collectionView.deleteSections(indexSet)
                maxSectionInsertedOpt = indexSet.first
            }
            // ---
        
            self.insertRowsRaw(configFiles: configFiles, maxSectionInsertedOpt: maxSectionInsertedOpt)
            
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    public func deleteSections(greaterOrEqualTo section: Int, andInsert configFiles: [GenericCollectionCellConfigurator], completion: (()->())? = nil) {
        let configFilesToDelete = self.configFiles.filter { $0.section >= section && $0.typeCell == .cell }
        
        var indexPaths = [IndexPath]()
        let allSections = Set(configFilesToDelete.map { $0.section }).sorted(by: >)
        for section in allSections {
            let rowsInSection = configFilesToDelete.filter { $0.section == section }
            
            for (index, _) in rowsInSection.enumerated() {
                indexPaths.append(IndexPath(item: index, section: section))
            }
        }
        
        collectionView.performBatchUpdates({
            
            // Delete sections if needed.
            let headersOrFootersInSection = self.configFiles.filter { $0.section >= section && $0.typeCell != .cell }.sorted { $0.section > $1.section }
            
            self.collectionView.deleteItems(at: indexPaths)
            self.configFiles = self.configFiles.filter { !($0.section >= section && $0.typeCell == .cell) }
            
            var sectionToDeleteFrom: Int
            if let maxSectionHeader = headersOrFootersInSection.first {
                sectionToDeleteFrom = maxSectionHeader.section + 1
            } else {
                let indexToDeleteFrom = getIndexSetToDelete(forSection: section)
                sectionToDeleteFrom = indexToDeleteFrom.first!
            }
            
            if sectionToDeleteFrom <= self.collectionView.numberOfSections - 1 {
                self.collectionView.deleteSections(IndexSet(integersIn: sectionToDeleteFrom ... self.collectionView.numberOfSections - 1))
            } else {
                sectionToDeleteFrom = self.collectionView.numberOfSections
            }
            // ---
            
            self.insertRowsRaw(configFiles: configFiles, maxSectionInsertedOpt: sectionToDeleteFrom)
            
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    public func deleteEverything(andInsert configFiles: [GenericCollectionCellConfigurator], completion: (()->())? = nil) {
        let insertIndexPaths = getStandaloneIndexPaths(configFiles: configFiles.filter { $0.typeCell == .cell })
        let maxOldSection = self.configFiles.sorted { $0.section > $1.section }.first?.section ?? 0
        let maxSection = configFiles.sorted { $0.section > $1.section }.first?.section ?? 0
        
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteSections(IndexSet(integersIn: 0 ... maxOldSection))
            
            self.configFiles = configFiles
            
            self.collectionView.insertSections(IndexSet(integersIn: 0 ... maxSection))
            self.collectionView.insertItems(at: insertIndexPaths)
            
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    // MARK: - Insert Methods
    public func insertRows(configFiles partialConfigFiles: [GenericCollectionCellConfigurator], maxSectionInsertedOpt: Int? = nil, completion: (()->())? = nil) {
        collectionView.performBatchUpdates({ 
            self.insertRowsRaw(configFiles: partialConfigFiles, maxSectionInsertedOpt: maxSectionInsertedOpt)
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    public func insertRowAtLocation(locationPosition: LocationPosition, filter: @escaping (GenericCollectionCellConfigurator)->Bool, configFile partialConfigFile: GenericCollectionCellConfigurator, completion: (()->())? = nil) {
        
        guard let configFile = getConfigFileWithoutDuplication(configFile: partialConfigFile) else { completion?(); return }
        guard let index = self.configFiles.firstIndex(where: filter) else { completion?(); return }
        var realIndex = index
        realIndex += locationPosition.rawValue
        guard let indexPath = self.getIndexPath(by: filter) else { completion?(); return }
        let realIndexPath = IndexPath(item: indexPath.item + locationPosition.rawValue, section: indexPath.section)
        
        collectionView.performBatchUpdates({
            if self.collectionView.numberOfSections <= configFile.section {
                self.collectionView.insertSections(
                    IndexSet(integersIn: (self.collectionView.numberOfSections...configFile.section))
                )
            }
            
            self.configFiles.insert(configFile, at: realIndex)
            self.collectionView.insertItems(at: [realIndexPath])
            
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    public func insertRowsAtTopOfEachSection(configFiles partialConfigFiles: [GenericCollectionCellConfigurator]) {
        let configFiles = getConfigFilesWithoutDuplication(configFiles: partialConfigFiles)
        let sections = Set(configFiles.map { $0.section }).sorted { $0 < $1 }
        var maxSectionInserted = self.collectionView.numberOfSections
        
        collectionView.performBatchUpdates({
            for section in sections {
                if maxSectionInserted <= section {
                    self.collectionView.insertSections(
                        IndexSet(integersIn: (maxSectionInserted...section))
                    )
                    maxSectionInserted = section + 1
                }
                let configFilesRowsForSection = configFiles.filter { $0.section == section && $0.typeCell == .cell }
                let configFilesForSection = configFiles.filter { $0.section == section }
                var indexPaths = [IndexPath]()
                for (index, _) in configFilesRowsForSection.enumerated() {
                    indexPaths.append(IndexPath(item: index, section: section))
                }
                self.configFiles.insert(contentsOf: configFilesForSection, at: 0)
                self.collectionView.insertItems(at: indexPaths)
            }
        }, completion: nil)
    }
    
    public func insertRowAtTopOfSection(configFile: GenericCollectionCellConfigurator) {
        insertRowsAtTopOfEachSection(configFiles: [configFile])
    }
    
    public func insertRow(configFile: GenericCollectionCellConfigurator, completion: (()->())? = nil) {
        insertRows(configFiles: [configFile], completion: completion)
    }
}

// MARK: - Private Inner Framework Methods
extension GenericCollectionViewDataSource {
    private func registerCells() {
        let classesToRegister = Set(configFiles)
        for classToRegister in classesToRegister {
            switch classToRegister.typeCell {
            case .cell:
                collectionView.register(
                    classToRegister.classType,
                    forCellWithReuseIdentifier: classToRegister.className)
            case .header:
                collectionView.register(
                    classToRegister.classType,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: classToRegister.className)
            case .footer:
                collectionView.register(
                    classToRegister.classType,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: classToRegister.className)
            }
        }
    }

    private func getIndexPaths(section: Int, configFiles: [GenericCollectionCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let numberOfCellsInSection = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        
        for (index, _) in configFiles.enumerated() {
            indexPaths.append(IndexPath(item: index + numberOfCellsInSection, section: section))
        }
        return indexPaths
    }
    
    private func getStandaloneIndexPaths(configFiles: [GenericCollectionCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let allSections = Set(configFiles.map { $0.section }).sorted(by: >)
        for section in allSections {
            let rowsInSection = configFiles.filter { $0.section == section }
            
            for (index, _) in rowsInSection.enumerated() {
                indexPaths.append(IndexPath(item: index, section: section))
            }
        }
        return indexPaths
    }
    
    private func getConfigFilesWithoutDuplication(configFiles partialConfigFiles: [GenericCollectionCellConfigurator]) -> [GenericCollectionCellConfigurator] {
        var uniqueIdentifiers = [String]()
        var partialCopyConfigFiles = [GenericCollectionCellConfigurator]()
        
        for configFile in partialConfigFiles {
            guard let identifier = configFile.diffableIdentifier else {
                partialCopyConfigFiles.append(configFile)
                continue
            }
            
            if uniqueIdentifiers.contains(identifier) { continue }
            uniqueIdentifiers.append(identifier)
            partialCopyConfigFiles.append(configFile)
        }
        
        return partialCopyConfigFiles.filter { configFile in
            guard let diffableIdentifier = configFile.diffableIdentifier else { return true }
            return (self.configFiles.first { $0.diffableIdentifier == diffableIdentifier }) == nil
        }
    }
    
    private func getConfigFileWithoutDuplication(configFile partialConfigFile: GenericCollectionCellConfigurator) -> GenericCollectionCellConfigurator? {
        return getConfigFilesWithoutDuplication(configFiles: [partialConfigFile]).first
    }
    
    private func getIndexSetToDelete(forSection section: Int) -> IndexSet {
        let sectionToDeleteFrom: Int
        if let sec = ((self.configFiles.filter { $0.section < section }).sorted { $0.section > $1.section }).first?.section {
            sectionToDeleteFrom = sec + 1
        } else {
            sectionToDeleteFrom = 1
        }
        
        return IndexSet(integersIn: sectionToDeleteFrom ... section)
    }
    
    private func insertRowsRaw(configFiles partialConfigFiles: [GenericCollectionCellConfigurator], maxSectionInsertedOpt: Int? = nil) {
        let configFiles = getConfigFilesWithoutDuplication(configFiles: partialConfigFiles)
        
        let sections = Set(configFiles.map { $0.section }).sorted { $0 < $1 }
        var maxSectionInserted = maxSectionInsertedOpt ?? self.collectionView.numberOfSections
        
        for section in sections {
            if maxSectionInserted <= section {
                self.collectionView.insertSections(
                    IndexSet(integersIn: (maxSectionInserted...section))
                )
                maxSectionInserted = section + 1
            }
            let configFilesRowsForSection = configFiles.filter { $0.section == section && $0.typeCell == .cell }
            let configFilesForSection = configFiles.filter { $0.section == section }
            let indexPaths = self.getIndexPaths(section: section, configFiles: configFilesRowsForSection)
            
            self.configFiles += configFilesForSection
            self.collectionView.insertItems(at: indexPaths)
        }
    }
}
