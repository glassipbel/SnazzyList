//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/// An instance of `SnazzyCollectionViewDataSource` is responsable for responding the methods that the collection view neeeds in order to display all the cells properly. You must have this instance in your desired `UIViewController`.
public class SnazzyCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    /**
     All the configFiles are going to be stored in this property.
     Most of the time you would use the convinience methods to insert and delete cells from the `UICollectionView` but in some cases you may need to access some of the configFiles stored in this property, that's why it's pubic.
    */
    public var configFiles: [SnazzyCollectionCellConfigurator] {
        didSet {
            registerCells()
        }
    }
    
    /**
     Creates a new instance of the `SnazzyCollectionViewDataSource`.
     - parameter collectionView: The `UICollectionView` that is gonna be handled by this class.
     - parameter configFiles: The initial configFiles that are gonna be shown in the `collectionView` at the beginning.
     - returns: An Instance of `SnazzyCollectionViewDataSource`
     */
    public init(collectionView: UICollectionView, configFiles: [SnazzyCollectionCellConfigurator]) {
        self.collectionView = collectionView
        self.configFiles = configFiles
        super.init()
        registerCells()
        self.collectionView.dataSource = self
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let configFile = (configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell })[indexPath.item]
        let optCell = collectionView.dequeueReusableCell(withReuseIdentifier: configFile.className, for: indexPath)
        
        guard let cell = optCell as? SnazzyCollectionCellProtocol else {
            return optCell
        }
        
        cell.collectionView(collectionView: collectionView, cellForItemAt: indexPath, with: configFile.item)
        return cell as! UICollectionViewCell
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let maxSectionNumber = (configFiles.map { $0.section }.sorted { $0.0 > $0.1 }).first else { return 1 }
        return maxSectionNumber + 1
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        return items
    }
    
    /**
     Internal Method for correct operation of `SnazzyCollectionViewDataSource`.
     */
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let typeCell = SnazzyCollectionCellType.getCollectionCellTypeBySupplementaryKind(kind: kind)
            else { return UICollectionReusableView() }
        
        guard let configFile = (configFiles.filter { $0.typeCell == typeCell && $0.section == indexPath.section }).first
            else { return UICollectionReusableView() }
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: configFile.className,
            for: indexPath) as! SnazzyCollectionReusableProtocol
        
        reusableView.collectionView(
            collectionView: collectionView,
            viewForSupplementaryElementOfKind: kind,
            at: indexPath,
            with: configFile.item)
        
        return reusableView as! UICollectionReusableView
    }
    
    private func registerCells() {
        let classesToRegister = Set(configFiles)
        for classToRegister in classesToRegister {
            switch classToRegister.typeCell {
            case .cell:
                switch classToRegister.cellOriginType {
                case .code:
                    collectionView.register(
                        classToRegister.classType,
                        forCellWithReuseIdentifier: classToRegister.className
                    )
                case .nib:
                    let nib = UINib(nibName: classToRegister.className, bundle: Bundle.main)
                    collectionView.register(
                        nib,
                        forCellWithReuseIdentifier: classToRegister.className
                    )
                }
            case .header:
                switch classToRegister.cellOriginType {
                case .code:
                    collectionView.register(
                        classToRegister.classType,
                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                        withReuseIdentifier: classToRegister.className
                    )
                case .nib:
                    let nib = UINib(nibName: classToRegister.className, bundle: Bundle.main)
                    collectionView.register(
                        nib,
                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                        withReuseIdentifier: classToRegister.className
                    )
                }
                
            case .footer:
                switch classToRegister.cellOriginType {
                case .code:
                    collectionView.register(
                        classToRegister.classType,
                        forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                        withReuseIdentifier: classToRegister.className
                    )
                case .nib:
                    let nib = UINib(nibName: classToRegister.className, bundle: Bundle.main)
                    collectionView.register(
                        nib,
                        forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                        withReuseIdentifier: classToRegister.className)
                }
            }
        }
    }
    
    weak fileprivate var collectionView: UICollectionView!
}

extension SnazzyCollectionViewDataSource {
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
    
    public func deleteRow(by filter: @escaping (SnazzyCollectionCellConfigurator)->Bool, completion: (()->())? = nil) {
        self.collectionView.performBatchUpdates({ 
            guard let indexPath = self.getIndexPath(by: filter) else { return }
            
            let numberOfSections = self.collectionView.numberOfSections
            
            self.configFiles = self.configFiles.filter { !filter($0) }
            
            let rowsWithHeaders = self.configFiles.filter { $0.section == indexPath.section }
            
            if numberOfSections - 1 == indexPath.section && rowsWithHeaders.count == 0 && numberOfSections > 1 {
                self.collectionView.deleteSections(IndexSet(integer: indexPath.section))
            }
            
            self.collectionView.deleteItems(at: [indexPath])
            
        }) { finish in
            if !finish { return }
            completion?()
        }
    }
    
    public func deleteAllRowsAt(section: Int, completion: (()->())? = nil) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
        if configFilesToDelete.count == 0 { return }
        
        var indexPaths = [IndexPath]()
        for (index, _) in configFilesToDelete.enumerated() {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        collectionView.performBatchUpdates({
    
            // Delete section if needed.
            let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
            if section == self.collectionView.numberOfSections - 1 &&
                self.collectionView.numberOfSections > 1 &&
                headersOrFootersInSection.count == 0 {
                self.collectionView.deleteSections(IndexSet(integer: section))
            }
            // ---
            
            self.collectionView.deleteItems(at: indexPaths)
            self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
            
        }) { completed in
            completion?()
        }
    }
    
    public func delete(at section: Int, andInsert configFiles: [SnazzyCollectionCellConfigurator], completion: (()->())? = nil) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
        var indexPaths = [IndexPath]()
        for (index, _) in configFilesToDelete.enumerated() {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        collectionView.performBatchUpdates({
            
            // Delete section if needed.
            let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
            var maxSectionInsertedOpt: Int? = nil
            
            if section == self.collectionView.numberOfSections - 1 &&
                self.collectionView.numberOfSections > 1 &&
                headersOrFootersInSection.count == 0 {
                self.collectionView.deleteSections(IndexSet(integer: section))
                maxSectionInsertedOpt = section
            }
            // ---
            
            self.collectionView.deleteItems(at: indexPaths)
            self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
            self.insertRows(configFiles: configFiles, maxSectionInsertedOpt: maxSectionInsertedOpt)
            
        }) { completed in
            completion?()
        }
    }
    
    public func deleteSections(greaterOrEqualTo section: Int, andInsert configFiles: [SnazzyCollectionCellConfigurator], completion: (()->())? = nil) {
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
            let headersOrFootersInSection = self.configFiles.filter { $0.section >= section && $0.typeCell != .cell }.sorted { $0.0.section > $0.1.section }
            
            var sectionToDeleteFrom: Int
            if let maxSectionHeader = headersOrFootersInSection.first {
                sectionToDeleteFrom = maxSectionHeader.section + 1
            } else {
                sectionToDeleteFrom = section
            }
            
            //In case the section is 0, then it shouldn't delete that section so i add 1 so the first section wont be deleted.
            sectionToDeleteFrom = sectionToDeleteFrom == 0 ? sectionToDeleteFrom + 1 : sectionToDeleteFrom
            // ---
            
            if sectionToDeleteFrom <= self.collectionView.numberOfSections - 1 {
                self.collectionView.deleteSections(IndexSet(integersIn: sectionToDeleteFrom ... self.collectionView.numberOfSections - 1))
            } else {
                sectionToDeleteFrom = self.collectionView.numberOfSections
            }
            // ---
            
            self.collectionView.deleteItems(at: indexPaths)
            self.configFiles = self.configFiles.filter { !($0.section >= section && $0.typeCell == .cell) }
            self.insertRows(configFiles: configFiles, maxSectionInsertedOpt: sectionToDeleteFrom, completion: completion)
            
        }) { completed in
            //completion?()
        }
    }

    public func insertRows(configFiles partialConfigFiles: [SnazzyCollectionCellConfigurator], maxSectionInsertedOpt: Int? = nil, completion: (()->())? = nil) {
        let configFiles = getConfigFilesWithoutDuplication(configFiles: partialConfigFiles)
        
        let sections = Set(configFiles.map { $0.section }).sorted { $0.0 < $0.1 }
        var maxSectionInserted = maxSectionInsertedOpt != nil ? maxSectionInsertedOpt! : self.collectionView.numberOfSections
        
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
                let indexPaths = self.getIndexPaths(section: section, configFiles: configFilesRowsForSection)
                
                self.configFiles += configFilesForSection
                self.collectionView.insertItems(at: indexPaths)
            }
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    public func insertRowAtLocation(locationPosition: SnazzyLocationPosition, filter: @escaping (SnazzyCollectionCellConfigurator)->Bool, configFile partialConfigFile: SnazzyCollectionCellConfigurator, completion: (()->())? = nil) {
        
        guard let configFile = getConfigFileWithoutDuplication(configFile: partialConfigFile) else { completion?(); return }
        guard let index = self.configFiles.index(where: filter) else { completion?(); return }
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
    
    public func insertRowsAtTopOfEachSection(configFiles partialConfigFiles: [SnazzyCollectionCellConfigurator]) {
        let configFiles = getConfigFilesWithoutDuplication(configFiles: partialConfigFiles)
        let sections = Set(configFiles.map { $0.section }).sorted { $0.0 < $0.1 }
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
    
    public func insertRowAtTopOfSection(configFile: SnazzyCollectionCellConfigurator) {
        insertRowsAtTopOfEachSection(configFiles: [configFile])
    }
    
    public func insertRow(configFile: SnazzyCollectionCellConfigurator, completion: (()->())? = nil) {
        insertRows(configFiles: [configFile], completion: completion)
    }
    
    public func getIndexPath(by filter: (SnazzyCollectionCellConfigurator)->Bool) -> IndexPath? {
        guard let configFile = configFiles.filter(filter).first else { return nil }
        
        let allRowsForSection = configFiles.filter { $0.section == configFile.section && $0.typeCell == .cell }
        
        guard let indexInSection = allRowsForSection.index(where: filter) else { return nil }
        
        return IndexPath(item: indexInSection, section: configFile.section)
    }
    
    fileprivate func getIndexPaths(section: Int, configFiles: [SnazzyCollectionCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let numberOfCellsInSection = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        
        for (index, _) in configFiles.enumerated() {
            indexPaths.append(IndexPath(item: index + numberOfCellsInSection, section: section))
        }
        return indexPaths
    }
    
    fileprivate func getConfigFilesWithoutDuplication(configFiles partialConfigFiles: [SnazzyCollectionCellConfigurator]) -> [SnazzyCollectionCellConfigurator] {
        var uniqueIdentifiers = [String]()
        var partialCopyConfigFiles = [SnazzyCollectionCellConfigurator]()
        
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
    
    fileprivate func getConfigFileWithoutDuplication(configFile partialConfigFile: SnazzyCollectionCellConfigurator) -> SnazzyCollectionCellConfigurator? {
        return getConfigFilesWithoutDuplication(configFiles: [partialConfigFile]).first
    }
}
