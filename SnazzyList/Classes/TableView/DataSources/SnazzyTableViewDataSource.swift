//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

public class SnazzyTableViewDataSource: NSObject, UITableViewDataSource {
    public init(tableView: UITableView, configFiles: [SnazzyTableCellConfigurator], sectionIndexTitles: [String]? = nil) {
        self.tableView = tableView
        self.configFiles = configFiles
        self.sectionIndexTitles = sectionIndexTitles
        super.init()
        registerCells()
        self.tableView.dataSource = self
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configFile = (configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell })[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: configFile.className, for: indexPath) as! SnazzyTableCellProtocol
        cell.tableView(tableView, cellForRowAt: indexPath, with: configFile.item)
        return cell as! UITableViewCell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let maxSectionNumber = (configFiles.map { $0.section }.sorted { $0.0 > $0.1 }).first else { return 1 }
        return maxSectionNumber + 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SnazzyTableCellProtocol else { return }
        
        let filteredConfigFiles = configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if filteredConfigFiles.count < indexPath.row + 1 { return }
        
        let configFile = filteredConfigFiles[indexPath.row]
        
        cell.tableView?(tableView, commit: editingStyle, forRowAt: indexPath, with: configFile.item)
    }
    
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
    
    weak public var tableView: UITableView!
    public var configFiles: [SnazzyTableCellConfigurator] {
        didSet {
            registerCells()
        }
    }
    public var sectionIndexTitles: [String]?
}

extension SnazzyTableViewDataSource {
    public func reload() {
        tableView.reloadData()
    }
    
    public func reloadAt(section: Int, animation: UITableViewRowAnimation = .automatic) {
        tableView.reloadSections(IndexSet(integer: section), with: animation)
    }
    
    public func reloadAtSections(indexSet: IndexSet, animation: UITableViewRowAnimation = .automatic) {
        tableView.reloadSections(indexSet, with: animation)
    }
    
    public func reloadAt(indexPaths: [IndexPath], animation: UITableViewRowAnimation = .automatic) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }
    
    public func reloadAt(indexPath: IndexPath, animation: UITableViewRowAnimation = .automatic) {
        reloadAt(indexPaths: [indexPath], animation: animation)
    }
        
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
    
    public func insertRowAtTopOfSection(configFile: SnazzyTableCellConfigurator) {
        insertRowsAtTopOfEachSection(configFiles: [configFile])
    }
    
    public func insertRow(configFile: SnazzyTableCellConfigurator) {
        insertRows(configFiles: [configFile])
    }
    
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
