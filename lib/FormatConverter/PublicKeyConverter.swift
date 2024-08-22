//
//  PublicKeyConverter.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

public class PublicKeyConverter {
    let publicKeyFilename: String

    public init(publicKeyFilename: String) {
        self.publicKeyFilename = publicKeyFilename
    }

    public var isPEM: Bool {
        let beginPemBlock = "-----BEGIN PUBLIC KEY-----"
        if let data = try? Data(contentsOf: URL(fileURLWithPath: publicKeyFilename)),
           String(data: data, encoding: .utf8)?.contains(beginPemBlock) ?? false {
            return true
        }
        return false
    }

    public func saveAs(derFilename: String) {
        let shell = Shell()
        shell.exec("rm \(derFilename)")
        PKILogger.v("Converting PEM file: \(self.publicKeyFilename) to DER file: \(derFilename)")
        guard self.isPEM else {
            PKILogger.v("File \(self.publicKeyFilename) is already a DER file! Just copying the file...")
            shell.exec("cp \(self.publicKeyFilename) \(derFilename)")
            return
        }
        shell.exec("openssl rsa -pubin -in \(self.publicKeyFilename) -inform PEM -outform DER -out \(derFilename)")
    }

    public func saveAs(pemFilename: String) {
        let shell = Shell()
        shell.exec("rm \(pemFilename)")
        PKILogger.v("Converting DER file: \(self.publicKeyFilename) to PEM file: \(pemFilename)")
        guard !self.isPEM else {
            PKILogger.v("File \(self.publicKeyFilename) is already a PEM file! Just copying the file...")
            shell.exec("cp \(self.publicKeyFilename) \(pemFilename)")
            return
        }
        shell.exec("openssl rsa -pubin -in \(self.publicKeyFilename) -inform DER -outform PEM -out \(pemFilename)")
    }
}
