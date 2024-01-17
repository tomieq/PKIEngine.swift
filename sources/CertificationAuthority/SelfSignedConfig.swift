//
//  SelfSignedConfig.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

enum SelfSignedConfig {
    
    static func with(info: CertificateInfo, writeTo configFilename: String) {
        var config = "HOME = ."
        
        func add(_ txt: String) {
            config.append("\n\(txt)")
        }
        // This option specifies the digest algorithm to use. Possible values include md5 sha1 mdc2
        add("default_md = sha256")
        // if set to the value no this disables prompting of certificate fields and just takes
        // values from the config file directly
        add("prompt = no")
        // if set to the value yes then field values to be interpreted as UTF8 strings,
        // by default they are interpreted as ASCII
        add("utf8 = yes")
        // This specifies the section containing the distinguished name fields to
        // prompt for when generating a certificate or certificate request.
        add("distinguished_name = req_distinguished_name")
        // The extensions to add to a certificate request
        add("x509_extensions = v3_extensions")
        
        // Leave as long names as it helps documentation
        add("[ req_distinguished_name ]")
        // Leave as long names as it helps documentation
        if let countryName = info.countryName {
            add("countryName = \(countryName)") // C
        }
        if let stateOrProvinceName = info.stateOrProvinceName {
            add("stateOrProvinceName = \(stateOrProvinceName)") // ST
        }
        if let localityName = info.localityName {
            add("localityName = \(localityName)") // L
        }
        if let organizationName = info.organizationName {
            add("organizationName = \(organizationName)") // O
        }
        if let organizationalUnitName = info.organizationalUnitName {
            add("organizationalUnitName = \(organizationalUnitName)") // OU
        }
        //add("organizationalUnitName = SmartCode Certificate Authority") // OU
        add("commonName = \(info.commonName)") // CN
        //add("emailAddress = admin@smartcode.com")
        
        // extensions section
        add("[ v3_extensions ]")
        // basic constraints extension tells whether certificate can be used to sign othet certificates

        // The pathlen parameter specifies the maximum number of CAs that can appear below this one in a chain.
        // A pathlen of zero means the CA cannot sign any sub-CA's, and can only sign end-entity certificates.
        add("basicConstraints=critical, CA:TRUE, pathlen:2")

        add("subjectKeyIdentifier = hash")
        // Key usage is a multi-valued extension consisting of a list of names of the permitted key usages.
        // The defined values are: digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement,
        // keyCertSign, cRLSign, encipherOnly, and decipherOnly.
        add("keyUsage = critical, keyCertSign, cRLSign")
        
        // put in the X509 the issuer's keyID and name - always, ever for self-signed certificate
        add("authorityKeyIdentifier = keyid, issuer:always")
        
        do {
            try config.write(toFile: configFilename, atomically: false, encoding: .utf8)
        } catch {
            Logger.v("Problem saving self signed config to file \(configFilename): \(error)")
        }
    }
}
