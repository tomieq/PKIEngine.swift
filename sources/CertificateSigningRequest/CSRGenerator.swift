//
//  CSRGenerator.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

enum CSRGenerator {
    // make sure private key exisis
    static func generate(using info: CertificateInfo,
                         type: CSRType,
                         privateKeyFilename: String,
                         csrOutput: String) {
        Logger.v("Generating Certificate Signing Request(\(csrOutput))...")
        let shell = Shell()
        
        let configFilename = "csr.config"
        CSRConfig.with(info: info, type: type, writeTo: configFilename)
        
        let output = shell.exec("openssl req -new -key \(privateKeyFilename) -out \(csrOutput) -config \(configFilename)")
        Logger.v(output)
        // to preview generated SCR, use:
        // openssl req -in ca.cert -noout -text
    }
}
