//
//  CertificateAuthority.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

class CertificateAuthority {
    let caX509Filename: String // might be self-signed
    let caPrivateKeyFilename: String
    
    init(caX509Filename: String, caPrivateKeyFilename: String) {
        self.caX509Filename = caX509Filename
        self.caPrivateKeyFilename = caPrivateKeyFilename
    }
    
    // sign certificate without any extensions
    func handle(csrFilename: String, x509Output: String) {
        let shell = Shell()

        _ = shell.exec("openssl x509 -req -days 90 -in \(csrFilename) -CA \(caX509Filename) -CAkey \(caPrivateKeyFilename) -out \(x509Output) -sha256")
        // to preview generated x509 certificate, call:
        // openssl x509 -in signed.pem -noout -text
    }
    
    // sign certificate without any extensions
    func handleExtendend(csrFilename: String, x509Output: String) {
        let shell = Shell()
        _ = shell.exec("openssl x509 -req  -in \(csrFilename) -CA \(caX509Filename) -CAkey \(caPrivateKeyFilename) -copy_extensions=copyall -out \(x509Output)")
        // to preview generated x509 certificate, call:
        // openssl x509 -in signed.pem -noout -text
    }
}
