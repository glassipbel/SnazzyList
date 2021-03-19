//
//  TableView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public class GenericTableViewDelegate: NSObject, UITableViewDelegate {
    
    public init(dataSource: GenericTableViewDataSource, actions: GenericTableActions? = nil) {
        self.dataSource = dataSource
        self.actions = actions
        
        super.init()
        self.dataSource.tableView.delegate = self
    }
    
    // MARK: - TableView Delegate Methods.
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let configFile = (self.dataSource.configFiles.filter { $0.typeCell == .header && $0.section == section }).first
            else { return nil }
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: configFile.className) as? GenericTableHeaderProtocol else { return nil }
        
        cell.tableView(tableView, viewForHeaderInSection: section, with: configFile.item)
        
        return cell as! UITableViewHeaderFooterView
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let configFile = (self.dataSource.configFiles.filter { $0.typeCell == .footer && $0.section == section }).first
            else { return nil }
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: configFile.className) as? GenericTableFooterProtocol else { return nil }
        
        cell.tableView(tableView, viewForFooterInSection: section, with: configFile.item)
        
        return cell as! UITableViewHeaderFooterView
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.row]
        
        switch configFile.sizingType {
        case .automatic: return UITableView.automaticDimension
            case .specificHeight(let height): return height.sizeMinOfZero
            case .cell(let cell): return cell.tableView(tableView, heightForRowAt: indexPath, with: configFile.item).sizeMinOfZero
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.row]
        
        switch configFile.sizingType {
            case .automatic: return self.cellHeightsDictionary[indexPath]?.sizeMinOfZero ?? 200.0
            case .specificHeight(let height): return max(height, 0.0).sizeMinOfZero
        case .cell(let cell): return cell.tableView(tableView, heightForRowAt: indexPath, with: configFile.item).sizeMinOfZero
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .header }).first else { return 0.0 }
        
        switch configFile.sizingType {
        case .automatic: return UITableView.automaticDimension
            case .specificHeight(let height): return height.sizeMinOfZero
        case .cell(let header): return header.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: section), with: configFile.item).sizeMinOfZero
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .header }).first else { return 0.0 }
        
        switch configFile.sizingType {
            case .automatic: return 200
            case .specificHeight(let height): return height.sizeMinOfZero
            case .cell(let header): return header.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: section), with: configFile.item).sizeMinOfZero
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .footer }).first else { return 0.0 }
        
        switch configFile.sizingType {
        case .automatic: return UITableView.automaticDimension
            case .specificHeight(let height): return height.sizeMinOfZero
            case .cell(let footer): return footer.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: section), with: configFile.item).sizeMinOfZero
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .footer }).first else { return 0.0 }
        
        switch configFile.sizingType {
            case .automatic: return 200.0
            case .specificHeight(let height): return height.sizeMinOfZero
            case .cell(let footer): return footer.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: section), with: configFile.item).sizeMinOfZero
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GenericTableCellProtocol else { return }
        cell.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GenericTableCellProtocol else { return }
        cell.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = cell.frame.size.height
        self.cellHeightsDictionary[indexPath] = height >= 0 ? height : 200.0
        guard let genericCell = cell as? GenericTableCellProtocol else { return }
        
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.row]
        
        genericCell.tableView?(tableView, willDisplay: cell, forRowAt: indexPath, with: configFile.item)
        
        if checkIfReachLastCellInTableView(indexPath: indexPath) {
            DispatchQueue.main.async { [weak self] in
                self?.actions?.reachLastCellInTableView?()
            }
        } else if checkIfReachFirstCellInTableView(indexPath: indexPath) {
            DispatchQueue.main.async { [weak self] in
                self?.actions?.reachFirstCellInTableView?()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let genericCell = cell as? GenericTableCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.row + 1 { return }
        
        let configFile = configFiles[indexPath.row]
        
        genericCell.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath, with: configFile.item)
    }
    // ---
    
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    private weak var dataSource: GenericTableViewDataSource!
    private weak var actions: GenericTableActions?
}

// MARK: - Private Inner Framework Methods
extension GenericTableViewDelegate {
    private func checkIfReachLastCellInTableView(indexPath: IndexPath) -> Bool {
        //Returning false because the user doesn't want to know if reached last cell in collection.
        if actions?.reachLastCellInTableView == nil { return false }
        
        let maxSection = dataSource.configFiles.map { $0.section }.sorted { $0 > $1 }.first
        let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
        
        if maxSection != indexPath.section { return false }
        if numberOfRowsInLastSection == 0 { return false }
        
        if numberOfRowsInLastSection >= 3 {
            return indexPath.row == numberOfRowsInLastSection - 3
        } else if numberOfRowsInLastSection == 2 {
            return indexPath.row == numberOfRowsInLastSection - 2
        }
        return indexPath.row == numberOfRowsInLastSection - 1
    }
    
    private func checkIfReachFirstCellInTableView(indexPath: IndexPath) -> Bool {
        //Returning false because the user doesn't want to know if reached first cell in collection.
        if actions?.reachFirstCellInTableView == nil { return false }

        let minSection = dataSource.configFiles.sorted { $0.section < $1.section }.first?.section
        
        if minSection != indexPath.section { return false }
        
        let numberOfRowsInFirstSection = dataSource.configFiles.filter { $0.section == minSection && $0.typeCell == .cell }.count
        
        if numberOfRowsInFirstSection == 0 { return false }
        
        return indexPath.row == 0
    }
}

extension GenericTableViewDelegate: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        actions?.willEndDragging?(scrollView: scrollView, velocity: velocity, targetContentOffset: targetContentOffset)
    }
}
