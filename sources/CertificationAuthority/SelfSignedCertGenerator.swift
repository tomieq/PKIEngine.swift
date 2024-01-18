//
//  SelfSignedCertGenerator.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

enum SelfSignedCertGenerator {
    // provide existing private key file and output cert file name to be created
    static func generate(using info: CertificateInfo,
                         privateKeyFilename: String,
                         x509Output: String,
                         outputFormat format: CertificateFormat,
                         expiration: CertificateExpiration) {
        Logger.v("Generating self-signed x509 certificate(\(x509Output))...")
        let shell = Shell()
        let configFilename = "selfSigned.".appendingRandomHexDigits(length: 12) + ".config"
        SelfSignedConfig.with(info: info, writeTo: configFilename)
        let output = shell.exec("openssl req -new -x509 -key \(privateKeyFilename) -out \(x509Output) \(format.opensslArg) \(expiration.opensslArg) -config \(configFilename)")
        print(output)
        try? FileManager.default.removeItem(atPath: configFilename)
        // to preview generated x509 certificate, call:
        // openssl x509 -in ca.pem -noout -text
    }
}
