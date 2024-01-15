//
//  CertificateInfo.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

struct CertificateInfo {
    let countryName: String
    let stateOrProvinceName: String
    let localityName: String
    let organizationName: String
    let organizationalUnitName: String?
    let commonName: String
    let alternativeNames: [String]
}
