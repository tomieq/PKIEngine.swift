//
//  CertificateFormat.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

public enum CertificateFormat {
    case pem
    case der
}

extension CertificateFormat {
    var opensslArg: String {
        switch self {
        case .pem:
            return "-outform PEM"
        case .der:
            return "-outform DER"
        }
    }
}
