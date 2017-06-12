//
//  Created by Kevin Belter on 2/8/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

public protocol SnazzyTableFooterProtocol {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int, with item: Any)
}
