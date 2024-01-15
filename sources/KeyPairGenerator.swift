//
//  KeyPairGenerator.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

enum KeyPairGenerator {
    
    static func generate(privateKeyFilename: String, publicKeyFilename: String) {
        let shell = Shell()
        Logger.v("Generating private(\(privateKeyFilename)) and public key(\(publicKeyFilename))...")
        _ = shell.exec("openssl genrsa -out \(privateKeyFilename) 2048")
        _ = shell.exec("openssl rsa -in \(privateKeyFilename) -pubout -out \(publicKeyFilename)")
        //Logger.v("Private key:\n\(self.shell.exec("cat \(self.privateKeyFilename)"))")
        //Logger.v("Public key:\n\(self.shell.exec("cat \(self.publicKeyFilename)"))")
        
    }
}
