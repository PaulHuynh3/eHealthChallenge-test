//
//  ViewController.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var cellHeights: [IndexPath: CGFloat] = [:]


    let viewModel = HomeViewModel(patientService: PatientInformationService.sharedInstance)

    // MARK: - ViewController Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configure(delegate: self)
        setup()
    }

    // MARK: - Setup

    func setup() {
        registerNibForTableView(cellType: String(describing: PatientNameCell.self), tableView: tableView)
        titleLabel.text = viewModel.setTitle(.loading)
        fetchPatientData()
    }

    private func fetchPatientData() {
        viewModel.fetchPatientInformation(with: URL(string:"http://hapi.fhir.org/baseDstu3/Patient?_count=10&_pretty=true"))
    }
}

extension HomeViewController: TableView {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: PatientNameCell.self, in: tableView, for: indexPath)
        cell.configure(data: viewModel.buildPatientData(entry: viewModel.entries[indexPath.row]))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return UITableView.automaticDimension }
        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let patientSelectedViewController = viewModel.didSelectPatient(entry: viewModel.entries[indexPath.row]) else { return }
        navigationController?.pushViewController(patientSelectedViewController, animated: true)
    }

}

extension HomeViewController: HomeViewModelDelegate {

    func openAlert(data: AlertManager.Data) {
        AlertManager.show(in: self, with: data)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func isResultsLoaded(isSuccessful: Bool) {
        titleLabel.text = isSuccessful
        ? self.viewModel.setTitle(.success)
        : self.viewModel.setTitle(.failure)
    }
}


