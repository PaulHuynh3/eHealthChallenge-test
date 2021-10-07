//
//  PatientSelectedViewController.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import UIKit

class PatientSelectedViewController: UIViewController {
    // MARK: - IBOulets

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    // MARK: - Properties
    var entry: Entry?


    // MARK: - Configuration

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func configure(entry: Entry) {
        self.entry = entry
    }

    func setup() {
        idLabel.text = entry?.resource?.id
        nameLabel.text = entry?.resource?.name?.first?.family
        birthDateLabel.text = entry?.resource?.birthDate

        let city = entry?.resource?.address?.first?.city ?? ""
        let state = entry?.resource?.address?.first?.state ?? ""
        let postalCode = entry?.resource?.address?.first?.postalCode ?? ""
        let country = entry?.resource?.address?.first?.country ?? ""
        addressLabel.text = "\(city)-\(state)-\(postalCode)-\(country)"
    }
}

