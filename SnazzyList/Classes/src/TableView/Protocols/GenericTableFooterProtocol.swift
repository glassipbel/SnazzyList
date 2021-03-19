//
//  TableView.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import UIKit

protocol GenericTableFooterProtocol {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int, with item: Any)
}
