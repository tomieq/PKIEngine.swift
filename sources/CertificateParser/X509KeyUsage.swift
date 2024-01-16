//
//  X509KeyUsage.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

enum X509KeyUsage: Int {
    case digitalSignature = 0
    case nonRepudiation = 1
    case keyEncipherment = 2
    case dataEncipherment = 3
    case keyAgreement = 4
    case keyCertSign = 5
    case cRLSign = 6
    case encipherOnly = 7
    case decipherOnly = 8
}

extension X509KeyUsage {
    var name: String {
        "\(self)"
    }
}
