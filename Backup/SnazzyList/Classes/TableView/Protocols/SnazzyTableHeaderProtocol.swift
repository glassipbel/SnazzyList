//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/**
 A Protocol that must be implemented in all your headers.
 */
public protocol SnazzyTableHeaderProtocol {
    /**
     This method will be called whenever the `UITableView` will call the `viewForHeaderInSection`.
     You will receive in the parameter `item` all the values that you entered when you created the configFile.
     
     - parameter tableView: The `UITableView` that is handling this header.
     - parameter viewForHeaderInSection: The section for this header.
     - parameter with: All the values that you entered when you created the configFile.
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int, with item: Any)
}
