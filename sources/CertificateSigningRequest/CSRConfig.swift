//
//  CSRConfig.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

enum CSRType {
    case intermediate
    case endUser
}

enum CSRConfig {
    static func with(info: CertificateInfo, type: CSRType, writeTo configFilename: String) {
        var config = "HOME = ."

        func add(_ txt: String) {
            config.append("\n\(txt)")
        }
        // This option specifies the digest algorithm to use. Possible values include md5 sha1 mdc2
        add("default_md = sha1")
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
        add("req_extensions = v3_req")

        // Leave as long names as it helps documentation
        add("[ req_distinguished_name ]")
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
        add("commonName = \(info.commonName)") // CN
        // add("emailAddress = admin@smartcode.com")

        // extensions section
        add("[ v3_req ]")
        // basic constraints extension tells whether certificate can be used to sign othet certificates
        switch type {
        case .intermediate:
            // The pathlen parameter specifies the maximum number of CAs that can appear below this one in a chain.
            // A pathlen of zero means the CA cannot sign any sub-CA's, and can only sign end-entity certificates.
            add("basicConstraints=CA:TRUE, pathlen:0")
            add("keyUsage = critical, digitalSignature, keyCertSign, cRLSign")
        case .endUser:
            add("basicConstraints=CA:FALSE")
            // Key usage is a multi-valued extension consisting of a list of names of the permitted key usages.
            // The defined values are: digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement,
            // keyCertSign, cRLSign, encipherOnly, and decipherOnly.
            add("keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment")
        }
        if !info.alternativeNames.isEmpty {
            add("subjectAltName=@my_subject_alt_names")
        }
        add("subjectKeyIdentifier = hash")
        /*
         This extension consists of a list of values indicating purposes for which the certificate public key can be used. Each value can be either a short text name or an OID. The following text names, and their intended meaning, are known:

         Value                  Meaning according to RFC 5280 etc.
         -----                  ----------------------------------
         serverAuth             SSL/TLS WWW Server Authentication
         clientAuth             SSL/TLS WWW Client Authentication
         codeSigning            Code Signing
         emailProtection        E-mail Protection (S/MIME)
         timeStamping           Trusted Timestamping
         OCSPSigning            OCSP Signing
         ipsecIKE               ipsec Internet Key Exchange
         msCodeInd              Microsoft Individual Code Signing (authenticode)
         msCodeCom              Microsoft Commercial Code Signing (authenticode)
         msCTLSign              Microsoft Trust List Signing
         msEFS                  Microsoft Encrypted File System
         */
        if type == .endUser {
            add("extendedKeyUsage = clientAuth, serverAuth") // , 1.2.3.4
        }

        // put in the X509 the issuer's keyID and name - always, ever for self-signed certificate
        // add("authorityKeyIdentifier = keyid, issuer:always")

        // Notice the various DNS names. Since the configuration parser does not allow multiple values
        // for the same name we use the @my_subject_alt_names and DNS.# with different numbers.
        if !info.alternativeNames.isEmpty {
            add("[ my_subject_alt_names ]")
            for (number, alternativeName) in info.alternativeNames.enumerated() {
                add("DNS.\(number + 1) = \(alternativeName)")
            }
        }
//        add("[ my_subject_alt_names ]")
//        add("DNS.1 = *.smartcode.com")
//        add("DNS.2 = .smartcode.pl")

        // Certificate Policies
        // This is a raw extension that supports all of the defined fields of the certificate extension.
        // Policies without qualifiers are specified by giving the OID. Multiple policies are comma-separated. For example:
        // add("certificatePolicies = 1.2.4.5, 1.1.3.4")

        do {
            try config.write(toFile: configFilename, atomically: false, encoding: .utf8)
        } catch {
            Logger.v("Problem writing to CSR file at \(configFilename): \(error)")
        }
    }
}
