//
//  TableView.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import Foundation


import UIKit

protocol TableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func registerNibForTableView(cellType: String, tableView: UITableView)
}

extension TableView {
    func registerNibForTableView(cellType: String, tableView: UITableView) {
        let nib = UINib(nibName: cellType, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellType)
    }
}
