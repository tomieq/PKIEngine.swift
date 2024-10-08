//
//  CSRGenerator.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

public enum CSRGenerator {
    // make sure private key exisis
    public static func generate(using info: CertificateInfo,
                                type: CSRType,
                                privateKeyFilename: String,
                                csrOutput: String) {
        PKILogger.v("Generating Certificate Signing Request(\(csrOutput))...")
        let shell = Shell()

        let configFilename = "csr.".appendingRandomHexDigits(length: 12) + ".config"
        CSRConfig.with(info: info, type: type, writeTo: configFilename)

        let output = shell.exec("openssl req -new -key \(privateKeyFilename) -out \(csrOutput) -config \(configFilename)")
        PKILogger.v(output)
        try? FileManager.default.removeItem(atPath: configFilename)
        // to preview generated SCR, use:
        // openssl req -in ca.cert -noout -text
    }
}
