//
//  HomeViewModel.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import UIKit

class HomeViewModel {
    // MARK: - Properties

    private let builder = HomeBuilder()
    private let patientService: PatientInformation
    var delegate: HomeViewModelDelegate?
    var entries = [Entry]()

    var setTitle: (State) -> String = {
        switch $0 {
        case .loading:
            return "Loading Information"
        case .success:
            return "Patient Information"
        case .failure:
            return "Please try again"
        }
    }

    init(patientService: PatientInformation) {
        self.patientService = patientService
    }

    // MARK: - Configuration

    func configure(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func fetchPatientInformation(with url: URL?) {
        patientService.getPatientEntry(url: url) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case let .success(entries):
                self.entries = entries
                self.delegate?.isResultsLoaded(isSuccessful: true)
            case let .failure(error):
                self.delegate?.openAlert(data: self.builder.buildErrorAlert(error: error))
                self.delegate?.isResultsLoaded(isSuccessful: false)
            }
            self.delegate?.reloadData()
        }
    }

    func didSelectPatient(entry: Entry) -> PatientSelectedViewController? {
        guard let patientSelectedViewController = UIStoryboard(name: "PatientSelectedViewController", bundle: nil).instantiateViewController(withIdentifier: String(describing: PatientSelectedViewController.self)) as? PatientSelectedViewController else { return nil }
        patientSelectedViewController.configure(entry: entry)
        return patientSelectedViewController
    }

    func buildPatientData(entry: Entry) -> PatientNameCell.Data {
        return builder.buildPatientData(entry: entry)
    }
}

enum State {
    case loading
    case success
    case failure
}

protocol HomeViewModelDelegate: AnyObject {
    func openAlert(data: AlertManager.Data)
    func reloadData()
    func isResultsLoaded(isSuccessful: Bool)
}
