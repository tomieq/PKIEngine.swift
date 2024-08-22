//
//  X509Certificate+prettyPrint.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

extension X509Certificate {
    public var prettyPrint: String {
        func add(_ label: String, _ txt: CustomStringConvertible?) {
            guard let txt = txt else { return }
            output.append("\n\(label)\n\t\(txt)")
        }
        func format(_ date: Date?) -> String? {
            guard let date = date else { return nil }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            return dateFormatter.string(from: date)
        }
        var output = "----------- BEGIN PREVIEW -----------"
        let isRoot = subjectDistinguishedName == issuerDistinguishedName
        if isRoot {
            add("Type", "Self-signed root certificate")
        }
        add("Subject Name", subjectDistinguishedName)
        add("Issuer Name", issuerDistinguishedName)
        add("Serial number", serialNumber?.hexString.chunked(by: 2).joined(separator: " "))
        add("Version", version)
        add("Signature algorithm", sigAlgName)

        add("Not valid before", format(notBefore))
        var expirationComment = ""
        if let expirationDate = notAfter {
            if expirationDate < Date() {
                expirationComment = " EXPIRED!"
            } else {
                expirationComment = " [will expire in \(Calendar(identifier: .gregorian).numberOfDaysBetween(Date(), and: expirationDate)) days]"
            }
        }
        add("Not valid after", format(notAfter)?.appending(expirationComment))
        if !subjectAlternativeNames.isEmpty {
            add("[Extension] Alternative names", subjectAlternativeNames.joined(separator: ", "))
        }
        add("[Extension] Key Usage", keyUsage.enumerated().filter{ $0.element }.compactMap{ X509KeyUsage(rawValue: $0.offset)?.name }.joined(separator: ", "))
        if !extendedKeyUsage.isEmpty {
            add("[Extension] Extended Key Usage", extendedKeyUsage.compactMap { OID.description(of: $0)?.appending(" (\($0))") }.joined(separator: "\n\t"))
        }
        if let basic = extensionObject(oid: .basicConstraints) as? BasicConstraintExtension {
            add("[Extension] Certificate Authority", basic.isCA)
        }
        if let subjectExtension = self.extensionObject(oid: .subjectKeyIdentifier) {
            add("[Extension] Subject Key Identifier", subjectExtension.valueAsBlock?.rawValue?.hexString.chunked(by: 2).dropFirst(2).joined(separator: " "))
        }
        if !isRoot, let authorityExtension = self.extensionObject(oid: .authorityKeyIdentifier) {
            add("[Extension] Authority Key Identifier", authorityExtension.valueAsBlock?.rawValue?.hexString.chunked(by: 2).dropFirst(4).joined(separator: " "))
        }
        output.append("\n----------- END PREVIEW -----------")
        return output
    }
}
