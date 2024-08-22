//
//  CertificateInfo.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

public struct CertificateInfo {
    let countryName: String?
    let stateOrProvinceName: String?
    let localityName: String?
    let organizationName: String?
    let organizationalUnitName: String?
    let commonName: String
    let alternativeNames: [String]

    public init(countryName: String? = nil,
                stateOrProvinceName: String? = nil,
                localityName: String? = nil,
                organizationName: String? = nil,
                organizationalUnitName: String? = nil,
                commonName: String,
                alternativeNames: [String] = []) {
        self.countryName = countryName
        self.stateOrProvinceName = stateOrProvinceName
        self.localityName = localityName
        self.organizationName = organizationName
        self.organizationalUnitName = organizationalUnitName
        self.commonName = commonName
        self.alternativeNames = alternativeNames
    }
}
