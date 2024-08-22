//
//  CertificateExpiration.swift
//
//
//  Created by Tomasz on 17/01/2024.
//

import Foundation

public enum CertificateExpiration {
    case days(Int)
    case months(Int)
    case years(Int)
}

extension CertificateExpiration {
    var opensslArg: String {
        switch self {
        case .days(let number):
            return "-days \(number)"
        case .months(let number):
            return "-days \(number * 30)"
        case .years(let number):
            return "-days \(number * 365)"
        }
    }
}
