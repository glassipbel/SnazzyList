//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

public protocol SnazzyTableHeaderProtocol {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int, with item: Any)
}
