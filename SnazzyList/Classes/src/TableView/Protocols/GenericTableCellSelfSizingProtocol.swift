//
//  TableView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

public protocol GenericTableCellSelfSizingProtocol {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath, with item: Any) -> CGFloat
}
