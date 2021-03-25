//
//  TableView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public class GenericTableViewDataSource: NSObject, UITableViewDataSource {
    weak var tableView: UITableView!
    public var configFiles: [GenericTableCellConfigurator] {
        didSet {
            registerCells()
        }
    }
    
    public init(tableView: UITableView, configFiles: [GenericTableCellConfigurator], sectionIndexTitlesDatasource: GenericTableSectionIndexTitlesDatasource? = nil) {
        self.tableView = tableView
        self.configFiles = configFiles
        self.sectionIndexTitlesDatasource = sectionIndexTitlesDatasource
        super.init()
        registerCells()
        self.tableView.dataSource = self
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.sectionIndexTitlesDatasource?.sectionForSectionIndexTitle(title: title, at: index) ?? 0
    }

    // MARK: - TableView Data Source Methods.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configFile = (configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell })[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: configFile.className, for: indexPath)
        cell.accessibilityIdentifier = "\(type(of: cell)).s\(indexPath.section)-r\(indexPath.row)"
        cell.isAccessibilityElement = false
        (cell as! GenericTableCellProtocol).tableView(tableView, cellForRowAt: indexPath, with: configFile.item)
        
        var accessibilityInfo = configFile.accessibilityInfo
        accessibilityInfo?.indexPath = indexPath
        cell.setupAccessibilityIdentifiersForViewProperties(withAccessibilityInfo: accessibilityInfo)
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let maxSectionNumber = (configFiles.map { $0.section }.sorted { $0 > $1 }).first else { return 1 }
        return maxSectionNumber + 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionIndexTitlesDatasource?.sectionIndexTitles
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? GenericTableCellProtocol else { return }
        
        let filteredConfigFiles = configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if filteredConfigFiles.count < indexPath.row + 1 { return }
        
        let configFile = filteredConfigFiles[indexPath.row]
        
        cell.tableView?(tableView, commit: editingStyle, forRowAt: indexPath, with: configFile.item)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? GenericTableCellProtocol else { return false }
        
        let filteredConfigFiles = configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if filteredConfigFiles.count < indexPath.row + 1 { return false }
        
        let configFile = filteredConfigFiles[indexPath.row]
        
        return cell.tableView?(tableView, canEditRowAt: indexPath, with: configFile.item) ?? false
    }
    // ---
    private weak var sectionIndexTitlesDatasource: GenericTableSectionIndexTitlesDatasource?
}

extension GenericTableViewDataSource {
    // MARK: - Util Public Methods.
    public func getCell<T>(by filter: (GenericTableCellConfigurator) -> Bool) -> T? {
        guard let indexPath = getIndexPath(by: filter) else { return nil }
        return self.tableView.cellForRow(at: indexPath) as? T
    }
    
    public func getIndexPath(by filter: (GenericTableCellConfigurator) -> Bool) -> IndexPath? {
        guard let configFile = configFiles.filter(filter).first else { return nil }
        
        let allRowsForSection = configFiles.filter { $0.section == configFile.section && $0.typeCell == .cell }
        
        guard let indexInSection = allRowsForSection.firstIndex(where: filter) else { return nil }
        
        return IndexPath(item: indexInSection, section: configFile.section)
    }
    
    public func getAllIndexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let numberOfSections = tableView.numberOfSections - 1
        if numberOfSections == 0 { return [] }
        
        for section in 0 ... numberOfSections {
            let configFilesForSection = self.configFiles.filter { $0.typeCell == .cell && $0.section == section }
            for index in configFilesForSection.indices {
                indexPaths.append(IndexPath(item: index, section: section))
            }
        }
        
        return indexPaths
    }
    
    public func update<T, U: UITableViewCell>(cellFinder filter: @escaping (GenericTableCellConfigurator) -> Bool, updates: ((T, U?) -> Void)) {
        guard let item = configFiles.first(where: filter)?.item as? T else { return }
        guard let indexPath = getIndexPath(by: filter) else {
            updates(item, nil)
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as? U
        updates(item, cell)
    }
    
    public func reload() {
        tableView.reloadData()
    }
    
    public func reloadAt(section: Int, animation: UITableView.RowAnimation = .automatic) {
        tableView.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    public func reloadAtSections(indexSet: IndexSet, animation: UITableView.RowAnimation = .automatic) {
        tableView.reloadSections(indexSet, with: animation)
    }
    
    public func reloadAt(indexPaths: [IndexPath], animation: UITableView.RowAnimation = .automatic) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }
    
    public func reloadAt(indexPath: IndexPath, animation: UITableView.RowAnimation = .automatic) {
        reloadAt(indexPaths: [indexPath], animation: animation)
    }
    
    // MARK: - Delete Methods.
    public func deleteRow(with animation: UITableView.RowAnimation = .automatic, filter: @escaping (GenericTableCellConfigurator) -> Bool) {
        
        guard let indexPath = self.getIndexPath(by: filter) else { return }
        
        tableView.beginUpdates()
        
        self.configFiles = self.configFiles.filter { !filter($0) }
        tableView.deleteRows(at: [indexPath], with: animation)
        
        let numberOfSections = self.tableView.numberOfSections
        let rowsWithHeaders = self.configFiles.filter { $0.section == indexPath.section }
        
        if numberOfSections - 1 == indexPath.section && rowsWithHeaders.isEmpty && numberOfSections > 1 {
            self.tableView.deleteSections(getIndexSetToDelete(forSection: indexPath.section), with: animation)
        }
        
        tableView.endUpdates()
    }
    
    public func deleteRow(with animation: UITableView.RowAnimation = .automatic, filter: @escaping (GenericTableCellConfigurator) -> Bool, andInsert configFiles: [GenericTableCellConfigurator]) {
        
        guard let indexPath = self.getIndexPath(by: filter) else {
            insertRows(configFiles: configFiles)
            return
        }
        
        tableView.beginUpdates()
        
        self.configFiles = self.configFiles.filter { !filter($0) }
        tableView.deleteRows(at: [indexPath], with: animation)
        
        let numberOfSections = self.tableView.numberOfSections
        let rowsWithHeaders = self.configFiles.filter { $0.section == indexPath.section }
        
        if numberOfSections - 1 == indexPath.section && rowsWithHeaders.isEmpty && numberOfSections > 1 {
            self.tableView.deleteSections(getIndexSetToDelete(forSection: indexPath.section), with: animation)
        }
        
        insertRowsRaw(configFiles: configFiles)
        
        tableView.endUpdates()
    }
    
    public func deleteRow(with animation: UITableView.RowAnimation = .automatic, filter: @escaping (GenericTableCellConfigurator) -> Bool, andInsert configFile: GenericTableCellConfigurator) {
        
        deleteRow(with: animation, filter: filter, andInsert: [configFile])
    }
    
    public func deleteAllRowsAt(section: Int, with animation: UITableView.RowAnimation = .automatic) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
         if configFilesToDelete.isEmpty { return }
        
        var indexPaths = [IndexPath]()
        for index in configFilesToDelete.indices {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        tableView.beginUpdates()
        
        // Delete section if needed.
        let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
        
        self.tableView.deleteRows(at: indexPaths, with: animation)
        self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
        
        if section == self.tableView.numberOfSections - 1 &&
            self.tableView.numberOfSections > 1 &&
            headersOrFootersInSection.isEmpty {
            self.tableView.deleteSections(getIndexSetToDelete(forSection: section), with: animation)
        }
        // ---
        
        tableView.endUpdates()
    }
    
    public func delete(at section: Int, andInsert configFiles: [GenericTableCellConfigurator], withAnimation animation: UITableView.RowAnimation = .automatic) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
        var indexPaths = [IndexPath]()
        for index in configFilesToDelete.indices {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        tableView.beginUpdates()
        
        self.tableView.deleteRows(at: indexPaths, with: animation)
        self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
        
        // Delete section if needed.
        let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
        var maxSectionInsertedOpt: Int?
        
        if section == self.tableView.numberOfSections - 1 &&
            self.tableView.numberOfSections > 1 &&
            headersOrFootersInSection.isEmpty {
            let indexSet = getIndexSetToDelete(forSection: section)
            self.tableView.deleteSections(indexSet, with: animation)
            maxSectionInsertedOpt = indexSet.first
        }
        // ---
        
        self.insertRowsRaw(configFiles: configFiles, with: animation, maxSectionInsertedOpt: maxSectionInsertedOpt)
        tableView.endUpdates()
    }

    public func deleteEverything(andInsert configFiles: [GenericTableCellConfigurator], withAnimation animation: UITableView.RowAnimation = .automatic) {
        let insertIndexPaths = getStandaloneIndexPaths(configFiles: configFiles.filter { $0.typeCell == .cell })
        let maxOldSection = self.configFiles.sorted { $0.section > $1.section }.first?.section ?? 0
        let maxSection = configFiles.sorted { $0.section > $1.section }.first?.section ?? 0
        
        self.tableView.beginUpdates()
        self.tableView.deleteSections(IndexSet(integersIn: 0 ... maxOldSection), with: animation)
        self.configFiles = configFiles
        self.tableView.insertSections(IndexSet(integersIn: 0 ... maxSection), with: animation)
        self.tableView.insertRows(at: insertIndexPaths, with: animation)
        self.tableView.endUpdates()
    }
    
    // MARK: - Insert Methods.
    public func insertRows(configFiles: [GenericTableCellConfigurator], with animation: UITableView.RowAnimation = .automatic, maxSectionInsertedOpt: Int? = nil) {
        tableView.beginUpdates()
        self.insertRowsRaw(configFiles: configFiles, with: animation, maxSectionInsertedOpt: maxSectionInsertedOpt)
        tableView.endUpdates()
    }
    
    public func insertRowsAtTopOfEachSection(configFiles: [GenericTableCellConfigurator], with animation: UITableView.RowAnimation = .automatic) {
        let sections = Set(configFiles.map { $0.section }).sorted { $0 < $1 }
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
            for index in configFilesRowsForSection.indices {
                indexPaths.append(IndexPath(item: index, section: section))
            }
            self.configFiles.insert(contentsOf: configFilesForSection, at: 0)
            self.tableView.insertRows(at: indexPaths, with: animation)
        }
        
        tableView.endUpdates()
    }
    
    public func insertRowAtTopOfSection(configFile: GenericTableCellConfigurator) {
        insertRowsAtTopOfEachSection(configFiles: [configFile])
    }
    
    public func insertRow(configFile: GenericTableCellConfigurator, withAnimation: UITableView.RowAnimation = .automatic) {
        insertRows(configFiles: [configFile], with: withAnimation)
    }
}

// MARK: - Private Inner Framework Methods
extension GenericTableViewDataSource {
    private func registerCells() {
        let classesToRegister = Set(configFiles)
        for classToRegister in classesToRegister {
            switch classToRegister.typeCell {
            case .cell:
                tableView.register(
                    classToRegister.classType,
                    forCellReuseIdentifier: classToRegister.className
                )
            case .header, .footer:
                tableView.register(
                    classToRegister.classType,
                    forHeaderFooterViewReuseIdentifier: classToRegister.className
                )
            }
        }
    }
    
    private func getIndexPaths(section: Int, configFiles: [GenericTableCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let numberOfCellsInSection = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        
        for index in configFiles.indices {
            indexPaths.append(IndexPath(item: index + numberOfCellsInSection, section: section))
        }
        return indexPaths
    }
    
    private func getStandaloneIndexPaths(configFiles: [GenericTableCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let allSections = Set(configFiles.map { $0.section }).sorted(by: >)
        for section in allSections {
            let rowsInSection = configFiles.filter { $0.section == section }
            
            for index in rowsInSection.indices {
                indexPaths.append(IndexPath(item: index, section: section))
            }
        }
        return indexPaths
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
    
    private func insertRowsRaw(configFiles: [GenericTableCellConfigurator], with animation: UITableView.RowAnimation = .automatic, maxSectionInsertedOpt: Int? = nil) {
        let sections = Set(configFiles.map { $0.section }).sorted { $0 < $1 }
        var maxSectionInserted = maxSectionInsertedOpt ?? self.tableView.numberOfSections
        
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
    }
}
