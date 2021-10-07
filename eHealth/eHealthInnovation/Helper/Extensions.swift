//
//  Extensions.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell>(cell identifier: T.Type, in tableView: UITableView, for indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: identifier), for: indexPath) as! T
    }
}
