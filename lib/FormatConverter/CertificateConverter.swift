//
//  CertificateConverter.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

public class CertificateConverter {
    let certFilename: String

    public init(certFilename: String) {
        self.certFilename = certFilename
    }

    public var isPEM: Bool {
        let beginPemBlock = "-----BEGIN CERTIFICATE-----"
        if let data = try? Data(contentsOf: URL(fileURLWithPath: certFilename)),
           String(data: data, encoding: .utf8)?.contains(beginPemBlock) ?? false {
            return true
        }
        return false
    }

    public func saveAs(derFilename: String) {
        let shell = Shell()
        shell.exec("rm \(derFilename)")
        PKILogger.v("Converting PEM file: \(self.certFilename) to DER file: \(derFilename)")
        guard self.isPEM else {
            PKILogger.v("File \(self.certFilename) is already a DER file! Just copying the file...")
            shell.exec("cp \(self.certFilename) \(derFilename)")
            return
        }
        shell.exec("openssl x509 -in \(self.certFilename) -outform DER -out \(derFilename)")
    }

    public func saveAs(pemFilename: String) {
        let shell = Shell()
        shell.exec("rm \(pemFilename)")
        PKILogger.v("Converting DER file: \(self.certFilename) to PEM file: \(pemFilename)")
        guard !self.isPEM else {
            PKILogger.v("File \(self.certFilename) is already a PEM file! Just copying the file...")
            shell.exec("cp \(self.certFilename) \(pemFilename)")
            return
        }
        shell.exec("openssl x509 -in \(self.certFilename) -outform PEM -out \(pemFilename)")
    }
}
