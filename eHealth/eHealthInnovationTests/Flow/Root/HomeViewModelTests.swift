//
//  HomeViewModelTests.swift
//  eHealthInnovationTests
//
//  Created by Paul Huynh on 2021-10-07.
//

import XCTest
@testable import eHealthInnovation

class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var patientInformationService = PatientInformationService.sharedInstance
    var mockHomeDelegate = MockHomeDelegate()

    override func setUp() {
        viewModel = HomeViewModel(patientService: MockPatientService())
        viewModel.delegate = mockHomeDelegate
    }

    func testTitleGivenLoadedState() {
        // Given
        let loadedStateTitle = viewModel.setTitle(.success)

        // Then
        XCTAssertEqual(loadedStateTitle, "Patient Information")
    }

    func testTitleGivenLoadingState() {
        // Given
        let loadingStateTitle = viewModel.setTitle(.loading)

        // Then
        XCTAssertEqual(loadingStateTitle, "Loading Information")
    }

    func testTitleGivenFailedState() {
        // Given
        let failedStateTitle = viewModel.setTitle(.failure)

        // Then
        XCTAssertEqual(failedStateTitle, "Please try again")
    }

    func testOpenAlertWasCalledGivenFailedRequest() {
        //GIVEN
        viewModel = HomeViewModel(patientService: MockPatientService(failService: true))
        viewModel.delegate = mockHomeDelegate

        //WHEN
        viewModel.fetchPatientInformation(with: URL(string:"http://hapi.fhir.org/baseDstu3/Patient?_pretty=true"))

        //THEN
        XCTAssertTrue(mockHomeDelegate.openAlertWasCalled && mockHomeDelegate.resultsLoadedWasCalled)
    }

    func testReloadDataAfterSuccessfulRequest() {
        //GIVEN
        viewModel = HomeViewModel(patientService: MockPatientService(failService: false))
        viewModel.delegate = mockHomeDelegate

        //WHEN
        viewModel.fetchPatientInformation(with: URL(string:"http://hapi.fhir.org/baseDstu3/Patient?_pretty=true"))

        //THEN
        XCTAssertTrue(mockHomeDelegate.reloadDataWasCalled && mockHomeDelegate.resultsLoadedWasCalled)
    }
}

extension HomeViewModelTests {
    class MockHomeDelegate: HomeViewModelDelegate {
        var openAlertWasCalled = false
        var reloadDataWasCalled = false
        var resultsLoadedWasCalled = false

        func openAlert(data: AlertManager.Data) {
            openAlertWasCalled = true
        }

        func reloadData() {
            reloadDataWasCalled = true
        }

        func isResultsLoaded(isSuccessful: Bool) {
            resultsLoadedWasCalled = true
        }
    }
}

class MockPatientService: PatientInformation {
    var shouldFailRequest = false

    init(failService: Bool = false) {
        shouldFailRequest = failService
    }

    func getPatientEntry(url: URL?, result: @escaping (Result<[Entry], NetworkError>) -> Void) {
        let entry = { () -> Entry in
            let givenName = Name(family: "Huynh", text: "Huynh", given: ["Paul"])
            let resource = Resource(id: "123456", name: [givenName], gender: "male", address: nil, birthDate: "1991-06-05")
            return Entry(fullUrl: "www.google.com", resource: resource)
        }
        shouldFailRequest ?
            result(.failure(.noData)) :
            result(.success([entry()]))
    }
}

