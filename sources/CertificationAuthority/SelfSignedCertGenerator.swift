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
                         x509Output: String) {
        Logger.v("Generating self-signed x509 certificate(\(x509Output))...")
        let shell = Shell()
        let configFilename = "ca.config"
        SelfSignedConfig.with(info: info, writeTo: configFilename)
        _ = shell.exec("openssl req -new -x509 -key \(privateKeyFilename) -out \(x509Output) -days 3650 -config \(configFilename)")
        try? FileManager.default.removeItem(atPath: configFilename)
        // to preview generated x509 certificate, call:
        // openssl x509 -in ca.pem -noout -text
        
    }
}
