//
//  PatientInformationService.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import Foundation

protocol PatientInformation {
    func getPatientEntry(url: URL?, result: @escaping (Result<[Entry], NetworkError>) -> Void)
}

class PatientInformationService: PatientInformation {

    static let sharedInstance = PatientInformationService()

    private init() {}

    var patientRepository: PatientInformationRepository = PatientRepository.sharedInstance

    func getPatientEntry(url: URL?, result: @escaping (Result<[Entry], NetworkError>) -> Void) {
        patientRepository.getPatientData(url: url) {
            switch $0 {
            case let .success(data):
                result(.success(data.entry))
            case let .failure(error):
                result(.failure(error))
            }
        }
    }
}
