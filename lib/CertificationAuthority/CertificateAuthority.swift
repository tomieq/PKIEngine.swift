//
//  CertificateAuthority.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

public class CertificateAuthority {
    let caPrivateKeyFilename: String
    let caX509Filename: String // might be self-signed

    public init(caPrivateKeyFilename: String, caX509Filename: String) {
        self.caPrivateKeyFilename = caPrivateKeyFilename
        self.caX509Filename = caX509Filename
    }

    // sign certificate without any extensions
    // process Certificate Signing Request
    public  func processCSR(csrFilename: String,
                    x509Output: String,
                    outputFormat format: CertificateFormat,
                    expiration: CertificateExpiration) {
        let shell = Shell()
        _ = shell.exec("rm \(x509Output)")
        let output = shell.exec("openssl x509 -req \(expiration.opensslArg) -in \(csrFilename) -CA \(self.caX509Filename) -CAkey \(self.caPrivateKeyFilename) -out \(x509Output) -sha256")
        print(output)
        // to preview generated x509 certificate, call:
        // openssl x509 -in signed.pem -noout -text
    }

    // sign certificate without any extensions
    // process Certificate Signing Request
    public func processCSRAddingExtensions(csrFilename: String,
                                    x509Output: String,
                                    outputFormat format: CertificateFormat,
                                    expiration: CertificateExpiration) {
        let shell = Shell()
        _ = shell.exec("rm \(x509Output)")
        let output = shell.exec("openssl x509 -req \(expiration.opensslArg) -in \(csrFilename) -CA \(self.caX509Filename) -CAkey \(self.caPrivateKeyFilename) -copy_extensions=copyall -out \(x509Output) \(format.opensslArg)")
        print(output)
        // to preview generated x509 certificate, call:
        // openssl x509 -in signed.pem -noout -text
    }
}
