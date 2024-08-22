//
//  ECCKeyPairGenerator.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

// Elliptic Curve Cryptography (ECC)
public enum ECCKeyPairGenerator {
    public static func generate(privateKeyFilename: String,
                         publicKeyFilename: String,
                         publicKeyFormat: CertificateFormat) {
        let shell = Shell()
        PKILogger.v("Generating elliptic curve private(\(privateKeyFilename)) and public key(\(publicKeyFilename))...")
        shell.exec("openssl ecparam -name prime256v1 -genkey -noout -out \(privateKeyFilename)")
        shell.exec("openssl ec -in \(privateKeyFilename) -pubout -out \(publicKeyFilename) \(publicKeyFormat.opensslArg)")
    }
}
