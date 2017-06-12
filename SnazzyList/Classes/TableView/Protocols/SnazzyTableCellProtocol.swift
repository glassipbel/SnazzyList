//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

@objc public protocol SnazzyTableCellProtocol {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, with item: Any)
    @objc optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath, with item: Any) -> Bool
    
}
