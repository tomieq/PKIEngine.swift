//
//  KeyPairGenerator.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

enum KeyPairGenerator {
    
    static func generate(privateKeyFilename: String, 
                         publicKeyFilename: String,
                         publicKeyFormat: CertificateFormat) {
        let shell = Shell()
        Logger.v("Generating private(\(privateKeyFilename)) and public key(\(publicKeyFilename))...")
        shell.exec("openssl genrsa -out \(privateKeyFilename) 2048")
        shell.exec("openssl rsa -in \(privateKeyFilename) -pubout -out \(publicKeyFilename) \(publicKeyFormat.opensslArg)")
    }
}
