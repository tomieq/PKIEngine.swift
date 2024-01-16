//
//  ECCKeyPairGenerator.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

// Elliptic Curve Cryptography (ECC)
enum ECCKeyPairGenerator {
    
    static func generate(privateKeyFilename: String,
                         publicKeyFilename: String,
                         publicKeyFormat: CertificateFormat) {
        let shell = Shell()
        Logger.v("Generating elliptic curve private(\(privateKeyFilename)) and public key(\(publicKeyFilename))...")
        _ = shell.exec("openssl ecparam -name prime256v1 -genkey -noout -out \(privateKeyFilename)")
        _ = shell.exec("openssl ec -in \(privateKeyFilename) -pubout -out \(publicKeyFilename) \(publicKeyFormat.opensslArg)")
    }
}
