//
//  PatientInformationRepository.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import Foundation

protocol PatientInformationRepository {
    func getPatientData(url: URL?, result: @escaping (Result<PatientData, NetworkError>) -> Void)
}

class PatientRepository: NetworkService, PatientInformationRepository {

    static let sharedInstance = PatientRepository()

    private override init() {}

    func getPatientData(url: URL?, result: @escaping (Result<PatientData, NetworkError>) -> Void) {
        fetch(method: .get, url: url) { (data: Result<PatientData, NetworkError>) in
            switch data {
            case let .success(data):
                result(.success(data))
            case let .failure(error):
                result(.failure(error))
            }
        }
    }
}
