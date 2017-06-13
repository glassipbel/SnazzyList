//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/// An instance of `SnazzyCollectionViewDelegate` is responsable for responding the methods that the collection view needs in order to display all the cells properly. You must have this instance in your desired `UIViewController`.
public class SnazzyTableViewDelegate: NSObject, UITableViewDelegate {
    
    /**
     Creates a new instance of the `SnazzyTableViewDelegate`.
     - parameter dataSource: The `SnazzyTableViewDataSource` that you instantiated in your `UIViewController`.
     - parameter reachLastCellInTableView: An optional callback that will be called when the user reachs the last cell in the `UITableView`.
     - returns: An Instance of `SnazzyTableViewDelegate`
     */
    public init(dataSource: SnazzyTableViewDataSource, reachLastCellInTableView: (()->())? = nil) {
        self.dataSource = dataSource
        self.reachLastCellInTableView = reachLastCellInTableView
        
        super.init()
        self.dataSource.tableView.delegate = self
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let configFile = (self.dataSource.configFiles.filter { $0.typeCell == .header && $0.section == section }).first
            else { return nil }
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: configFile.className) as? SnazzyTableHeaderProtocol else { return nil }
        
        cell.tableView(tableView, viewForHeaderInSection: section, with: configFile.item)
        
        return cell as! UITableViewHeaderFooterView
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let configFile = (self.dataSource.configFiles.filter { $0.typeCell == .footer && $0.section == section }).first
            else { return nil }
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: configFile.className) as? SnazzyTableFooterProtocol else { return nil }
        
        cell.tableView(tableView, viewForFooterInSection: section, with: configFile.item)
        
        return cell as! UITableViewHeaderFooterView
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.row]
        
        switch configFile.sizingType {
            case .automatic: return UITableViewAutomaticDimension
            case .specificHeight(let height): return height
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.row]
        
        switch configFile.sizingType {
            case .automatic: return UITableViewAutomaticDimension
            case .specificHeight(let height): return height
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .header }).first else { return 0.0 }
        
        switch configFile.sizingType {
            case .automatic: return UITableViewAutomaticDimension
            case .specificHeight(let height): return height
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .header }).first else { return 0.0 }
        
        switch configFile.sizingType {
            case .automatic: return UITableViewAutomaticDimension
            case .specificHeight(let height): return height
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .footer }).first else { return 0.0 }
        
        switch configFile.sizingType {
            case .automatic: return UITableViewAutomaticDimension
            case .specificHeight(let height): return height
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .footer }).first else { return 0.0 }
        
        switch configFile.sizingType {
            case .automatic: return UITableViewAutomaticDimension
            case .specificHeight(let height): return height
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SnazzyTableCellProtocol else { return }
        cell.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SnazzyTableCellProtocol else { return }
        cell.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let genericCell = cell as? SnazzyTableCellProtocol else { return }
        
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.row]
        
        genericCell.tableView?(tableView, willDisplay: cell, forRowAt: indexPath, with: configFile.item)
        
        if checkIfReachLastCellInTableView(indexPath: indexPath) {
            reachLastCellInTableView?()
        }
    }
    
    /**
     Internal Method for correct operation of `SnazzyList`.
     */
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let genericCell = cell as? SnazzyTableCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.row + 1 { return }
        
        let configFile = configFiles[indexPath.row]
        
        genericCell.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath, with: configFile.item)
    }
    
    fileprivate var reachLastCellInTableView: (()->())?
    weak fileprivate var dataSource: SnazzyTableViewDataSource!
}

extension SnazzyTableViewDelegate {
    fileprivate func checkIfReachLastCellInTableView(indexPath: IndexPath) -> Bool {
        //Returning false because the user doesn't want to know if reached last cell in collection.
        if reachLastCellInTableView == nil { return false }
        
        let maxSection = dataSource.configFiles.map { $0.section }.sorted { $0.0 > $0.1 }.first
        let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
        
        if maxSection != indexPath.section { return false }
        if numberOfRowsInLastSection == 0 { return false }
        
        if numberOfRowsInLastSection >= 3 {
            if indexPath.row == numberOfRowsInLastSection - 3 {
                return true
            }
        } else if numberOfRowsInLastSection == 2 {
            if indexPath.row == numberOfRowsInLastSection - 2 {
                return true
            }
        } else {
            if indexPath.row == numberOfRowsInLastSection - 1 {
                return true
            }
        }
        return false
    }
}
