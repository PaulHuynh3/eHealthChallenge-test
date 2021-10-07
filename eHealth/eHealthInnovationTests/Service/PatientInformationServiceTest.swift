//
//  PatientInformationServiceTest.swift
//  eHealthInnovationTests
//
//  Created by Paul Huynh on 2021-10-07.
//

import XCTest
@testable import eHealthInnovation

class PatientInformationServiceTest: XCTestCase {

    var patientInformationService = PatientInformationService.sharedInstance
    let url = URL(string:"http://hapi.fhir.org/baseDstu3/Patient?_pretty=true")

    func testGivenMockRepoFetchEntrySuccessfully() {
        // GIVEN
        let mockPatientRepository = MockPatientRepository(failRequest: false)
        patientInformationService.patientRepository = mockPatientRepository

        // WHEN
        var patientEntries = [Entry]()
        patientInformationService.getPatientEntry(url: url) { result in
            switch result {
            case let .success(entries):
                patientEntries = entries
            case .failure(_):
                XCTFail()
            }
        }

        // THEN
        XCTAssertEqual(patientEntries, [mockPatientRepository.entry()])
    }

    func testGivenMockRepoFetchEntryWithError() {
        // GIVEN
        let mockPatientRepository = MockPatientRepository(failRequest: true)
        patientInformationService.patientRepository = mockPatientRepository

        // WHEN
        var networkError: NetworkError?

        patientInformationService.getPatientEntry(url: url) {
            switch $0 {
            case .success(_):
                XCTFail()
            case let .failure(error):
                networkError = error
            }
        }
        // THEN
        XCTAssertNotNil(networkError)
    }
}

class MockPatientRepository: PatientInformationRepository {
    var shouldFailRequest = false

    init(failRequest: Bool) {
        shouldFailRequest = failRequest
    }

    var entry = { () -> Entry in
        let givenName = Name(family: "Huynh", text: "Huynh", given: ["Paul"])
        let resource = Resource(id: "123456", name: [givenName], gender: "male", address: nil, birthDate: "1991-06-05")
        return Entry(fullUrl: "www.google.com", resource: resource)
    }

    func getPatientData(url: URL?, result: @escaping (Result<PatientData, NetworkError>) -> Void) {
        shouldFailRequest ? result(.failure(.noData)) : result(.success(PatientData(entry: [entry()])))
    }
}

