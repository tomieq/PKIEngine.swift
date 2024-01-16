//
//  CertificateConverter.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

class CertificateConverter {
    let certFilename: String
    
    init(certFilename: String) {
        self.certFilename = certFilename
    }

    var isPEM: Bool {
        let beginPemBlock = "-----BEGIN CERTIFICATE-----"
        if let data = try? Data(contentsOf: URL(fileURLWithPath: certFilename)),
           String(data: data, encoding: .utf8)?.contains(beginPemBlock) ?? false {
            return true
        }
        return false
    }

    func saveAs(derFilename: String) {
        let shell = Shell()
        shell.exec("rm \(derFilename)")
        Logger.v("Converting PEM file: \(certFilename) to DER file: \(derFilename)")
        guard isPEM else {
            Logger.v("File \(certFilename) is already a DER file! Just copying the file...")
            shell.exec("cp \(certFilename) \(derFilename)")
            return
        }
        shell.exec("openssl x509 -in \(certFilename) -outform DER -out \(derFilename)")
    }

    func saveAs(pemFilename: String) {
        let shell = Shell()
        shell.exec("rm \(pemFilename)")
        Logger.v("Converting DER file: \(certFilename) to PEM file: \(pemFilename)")
        guard !isPEM else {
            Logger.v("File \(certFilename) is already a PEM file! Just copying the file...")
            shell.exec("cp \(certFilename) \(pemFilename)")
            return
        }
        shell.exec("openssl x509 -in \(certFilename) -outform PEM -out \(pemFilename)")
    }
}
