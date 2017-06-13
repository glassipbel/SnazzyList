//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/// An instance of `SnazzyTableViewDataSource` is responsable for responding the methods that the collection view needs in order to display all the cells properly. You must have this instance in your desired `UIViewController`.
public class SnazzyTableViewDataSource: NSObject, UITableViewDataSource {
    
    /**
     All the configFiles are going to be stored in this property.
     Most of the time you would use the convinience methods to insert and delete cells from the `UITableView` but in some cases you may need to access some of the configFiles stored in this property, that's why it's pubic.
     */
    public var configFiles: [SnazzyTableCellConfigurator] {
        didSet {
            registerCells()
        }
    }
    
    /**
     Creates a new instance of the `SnazzyTableViewDataSource`.
     - parameter tableView: The `UITableView` that is gonna be handled by this class.
     - parameter configFiles: The initial configFiles that are gonna be shown in the `tableView` at the beginning.
     - returns: An Instance of `SnazzyTableViewDataSource`
     */
    public init(tableView: UITableView, configFiles: [SnazzyTableCellConfigurator], sectionIndexTitles: [String]? = nil) {
        self.tableView = tableView
        self.configFiles = configFiles
        self.sectionIndexTitles = sectionIndexTitles
        super.init()
        registerCells()
        self.tableView.dataSource = self
    }

    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configFile = (configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell })[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: configFile.className, for: indexPath) as! SnazzyTableCellProtocol
        cell.tableView(tableView, cellForRowAt: indexPath, with: configFile.item)
        return cell as! UITableViewCell
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let maxSectionNumber = (configFiles.map { $0.section }.sorted { $0.0 > $0.1 }).first else { return 1 }
        return maxSectionNumber + 1
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SnazzyTableCellProtocol else { return }
        
        let filteredConfigFiles = configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if filteredConfigFiles.count < indexPath.row + 1 { return }
        
        let configFile = filteredConfigFiles[indexPath.row]
        
        cell.tableView?(tableView, commit: editingStyle, forRowAt: indexPath, with: configFile.item)
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SnazzyTableCellProtocol else { return false }
        
        let filteredConfigFiles = configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if filteredConfigFiles.count < indexPath.row + 1 { return false }
        
        let configFile = filteredConfigFiles[indexPath.row]
        
        return cell.tableView?(tableView, canEditRowAt: indexPath, with: configFile.item) ?? false
    }
    
    private func registerCells() {
        let classesToRegister = Set(configFiles)
        for classToRegister in classesToRegister {
            
            switch classToRegister.typeCell {
            case .cell:
                switch classToRegister.cellOriginType {
                case .code:
                    tableView.register(
                        classToRegister.classType,
                        forCellReuseIdentifier: classToRegister.className
                    )
                case .nib:
                    let nib = UINib(nibName: classToRegister.className, bundle: Bundle.main)
                    tableView.register(
                        nib,
                        forCellReuseIdentifier: classToRegister.className
                    )
                }
            case .header, .footer:
                switch classToRegister.cellOriginType {
                case .code:
                    tableView.register(
                        classToRegister.classType,
                        forHeaderFooterViewReuseIdentifier: classToRegister.className
                    )
                case .nib:
                    let nib = UINib(nibName: classToRegister.className, bundle: Bundle.main)
                    tableView.register(
                        nib,
                        forHeaderFooterViewReuseIdentifier: classToRegister.className
                    )
                }
            }
        }
    }
    
    weak var tableView: UITableView!
    private var sectionIndexTitles: [String]?
}

extension SnazzyTableViewDataSource {
    /// This method will reload the `UICollectionView`, without animations.
    public func reload() {
        tableView.reloadData()
    }
    
    /// This method will reload an specific section at the `UICollectionView`, animated.
    public func reloadAt(section: Int, animation: UITableViewRowAnimation = .automatic) {
        tableView.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    /// This method will reload sections at the `UICollectionView`, animated.
    public func reloadAtSections(indexSet: IndexSet, animation: UITableViewRowAnimation = .automatic) {
        tableView.reloadSections(indexSet, with: animation)
    }
    
    /// This method will reload the specified indexPaths at the `UICollectionView`, animated.
    public func reloadAt(indexPaths: [IndexPath], animation: UITableViewRowAnimation = .automatic) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }
    
    /// This method will reload the `UICollectionView` for the specified `IndexPath`
    public func reloadAt(indexPath: IndexPath, animation: UITableViewRowAnimation = .automatic) {
        reloadAt(indexPaths: [indexPath], animation: animation)
    }
    
    /**
     This method will delete only one cell for the specified filter.
     **Caution** if the filter specified in the parameter matches more than one cell, then you will have an unwanted behavior.
     For deleting more than one cell, use the method `deleteAllRowsAt:section`.
     - parameter with: The desired animation.
     - parameter filter: Closure that indicates what cell should be deleted.
     */
    public func deleteRow(with animation: UITableViewRowAnimation = .automatic, filter: @escaping (SnazzyTableCellConfigurator)->Bool) {
        tableView.beginUpdates()
        
        guard let indexPath = self.getIndexPath(by: filter) else { return }
        
        let numberOfSections = self.tableView.numberOfSections
        self.configFiles = self.configFiles.filter { !filter($0) }
        let rowsWithHeaders = self.configFiles.filter { $0.section == indexPath.section }
        
        if numberOfSections - 1 == indexPath.section && rowsWithHeaders.count == 0 && numberOfSections > 1 {
            self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: animation)
        }
        
        tableView.deleteRows(at: [indexPath], with: animation)
        
        tableView.endUpdates()
    }
    
    /**
     This method will delete all cells at the specified section.
     - parameter section: The section for deleting all the cells.
     - parameter with: The desired animation.
     */
    public func deleteAllRowsAt(section: Int, with animation: UITableViewRowAnimation = .automatic) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
         if configFilesToDelete.count == 0 { return }
        
        var indexPaths = [IndexPath]()
        for (index, _) in configFilesToDelete.enumerated() {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        tableView.beginUpdates()
        
        // Delete section if needed.
        let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
        if section == self.tableView.numberOfSections - 1 &&
            self.tableView.numberOfSections > 1 &&
            headersOrFootersInSection.count == 0 {
            self.tableView.deleteSections(IndexSet(integer: section), with: animation)
        }
        // ---
        
        self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
        self.tableView.deleteRows(at: indexPaths, with: animation)
        
        tableView.endUpdates()
    }

    /**
     This method will insert all the cells specified at `configFiles`.
     The configFiles don't need to be sorted by sections but the order of the array is gonna be the order of the cells for every section.
     
     For example if you insert these configFiles for sections:
     
     [ConfigFile 1: Section 1]
     [ConfigFile 2: Section 2]
     [ConfigFile 3: Section 2]
     [ConfigFile 4: Section 1]
     [ConfigFile 5: Section 3]
     [ConfigFile 6: Section 1]
     
     Then the order of the cells are going to be:
     
     ConfigFile 1
     ConfigFile 4
     ConfigFile 6
     ConfigFile 2
     ConfigFile 3
     ConfigFile 5
     
     - parameter configFiles: The array of configFiles that are going to be inserted.
     - parameter with: The desired animation.
     */
    public func insertRows(configFiles: [SnazzyTableCellConfigurator], with animation: UITableViewRowAnimation = .automatic) {
        
        let sections = Set(configFiles.map { $0.section }).sorted { $0.0 < $0.1 }
        var maxSectionInserted = self.tableView.numberOfSections
        
        tableView.beginUpdates()
        
        for section in sections {
            if maxSectionInserted <= section {
                self.tableView.insertSections(
                    IndexSet(integersIn: (maxSectionInserted...section)),
                    with: animation
                )
                maxSectionInserted = section + 1
            }
            let configFilesRowsForSection = configFiles.filter { $0.section == section && $0.typeCell == .cell }
            let configFilesForSection = configFiles.filter { $0.section == section }
            let indexPaths = self.getIndexPaths(section: section, configFiles: configFilesRowsForSection)
            self.configFiles += configFilesForSection
            self.tableView.insertRows(at: indexPaths, with: animation)
        }
        tableView.endUpdates()
    }
    
    /**
     This method will insert the cell specified at `configFile`.
     - parameter configFile: The configFile that is going to be inserted.
     */
    public func insertRow(configFile: SnazzyTableCellConfigurator) {
        insertRows(configFiles: [configFile])
    }
    
    /**
     This method will insert all the configFiles specified at the parameter `configFiles` at top of each section corresponding to each section respecting the order within each section.
     - parameter configFiles: The array of configFiles that are going to be inserted.
     */
    public func insertRowsAtTopOfEachSection(configFiles: [SnazzyTableCellConfigurator], with animation: UITableViewRowAnimation = .automatic) {
        let sections = Set(configFiles.map { $0.section }).sorted { $0.0 < $0.1 }
        var maxSectionInserted = self.tableView.numberOfSections
        
        tableView.beginUpdates()
        
        for section in sections {
            if maxSectionInserted <= section {
                self.tableView.insertSections(
                    IndexSet(integersIn: (maxSectionInserted...section)),
                    with: animation
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
            self.tableView.insertRows(at: indexPaths, with: animation)
        }
        
        tableView.endUpdates()
    }
    
    /**
     This method will insert the configFile specified at the parameter `configFile` at top of its section.
     - parameter configFile: The configFile that is going to be inserted.
     */
    public func insertRowAtTopOfSection(configFile: SnazzyTableCellConfigurator) {
        insertRowsAtTopOfEachSection(configFiles: [configFile])
    }
    
    /**
     This method will retrieve the IndexPath given by the filter. If the filter don't match any result it will return nil, on the other hand if the filter matches multiple results it will retrieve the first one.
     You can use the indexPath after that to reload that cell or another operations that require the indexPath.
     - parameter by: A Closure that represents the cell that you want to find its IndexPath.
     - returns: The IndexPath that matched the given filter.
     */
    public func getIndexPath(by filter: (SnazzyTableCellConfigurator)->Bool) -> IndexPath? {
        guard let configFile = configFiles.filter(filter).first else { return nil }
        
        let allRowsForSection = configFiles.filter { $0.section == configFile.section && $0.typeCell == .cell }
        
        guard let indexInSection = allRowsForSection.index(where: filter) else { return nil }
        
        return IndexPath(item: indexInSection, section: configFile.section)
    }
    
    fileprivate func getIndexPaths(section: Int, configFiles: [SnazzyTableCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let numberOfCellsInSection = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        
        for (index, _) in configFiles.enumerated() {
            indexPaths.append(IndexPath(item: index + numberOfCellsInSection, section: section))
        }
        return indexPaths
    }
}
