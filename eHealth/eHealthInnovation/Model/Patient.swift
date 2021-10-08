//
//  Model.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//

import Foundation

//Move to seprate Models later
struct PatientData: Codable {
    let entry: [Entry]
}

struct Entry: Codable, Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.resource?.id == rhs.resource?.id
    }

    let fullUrl: String?
    let resource: Resource?
}

struct Resource: Codable {
    let id: String?
    let name: [Name]? // - data not always coming back
    let gender: String? // - data not always coming back
    let address: [Address]? // - data not always coming back
    let birthDate: String? // - data not always coming back
}

struct Address: Codable {
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
}

struct Name: Codable {
    let family: String?
    let text: String?
    let given: [String]?
}

