//
//  KeyPairGenerator.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

public enum KeyPairGenerator {
    public static func generate(privateKeyFilename: String,
                                publicKeyFilename: String,
                                publicKeyFormat: CertificateFormat) {
        let shell = Shell()
        PKILogger.v("Generating private(\(privateKeyFilename)) and public key(\(publicKeyFilename))...")
        shell.exec("openssl genrsa -out \(privateKeyFilename) 2048")
        shell.exec("openssl rsa -in \(privateKeyFilename) -pubout -out \(publicKeyFilename) \(publicKeyFormat.opensslArg)")
    }
}
