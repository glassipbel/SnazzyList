//
//  Created by Kevin Belter on 2/8/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

/**
 A Protocol that must be implemented in all your footers.
 */
public protocol SnazzyTableFooterProtocol {
    /**
     This method will be called whenever the `UITableView` will call the `viewForFooterInSection`.
     You will receive in the parameter `item` all the values that you entered when you created the configFile.
     
     - parameter tableView: The `UITableView` that is handling this footer.
     - parameter viewForFooterInSection: The section for this footer.
     - parameter with: All the values that you entered when you created the configFile.
     */
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int, with item: Any)
}
