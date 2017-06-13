//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/**
 A Protocol that must be implemented in all your `UITableViewCell`.
 */
@objc public protocol SnazzyTableCellProtocol {
    /**
     This method will be called whenever the `UITableView` will call the `cellForRowAt`.
     You will receive in the parameter `item` all the values that you entered when you created the configFile.
     
     - parameter tableView: The `UITableView` that is handling this row.
     - parameter cellForRowAt: The indexPath for this row.
     - parameter with: All the values that you entered when you created the configFile.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath, with item: Any) -> Bool
    
}
