//
//  PatientNameCell.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import UIKit

class PatientNameCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(data: Data) {
        nameLabel.text = data.name == nil ? data.id : data.name
    }

    struct Data {
        let name: String?
        let id: String
    }
}
