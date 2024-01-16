//
//  X509Extension+AltName.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

extension X509Extension {
    
    // Used for SubjectAltName and IssuerAltName
    // Every name can be one of these subtype:
    //  - otherName      [0] INSTANCE OF OTHER-NAME,
    //  - rfc822Name     [1] IA5String,
    //  - dNSName        [2] IA5String,
    //  - x400Address    [3] ORAddress,
    //  - directoryName  [4] Name,
    //  - ediPartyName   [5] EDIPartyName,
    //  - uniformResourceIdentifier [6] IA5String,
    //  - IPAddress      [7] OCTET STRING,
    //  - registeredID   [8] OBJECT IDENTIFIER
    //
    // Result does not support: x400Address and ediPartyName
    //
    var alternativeNameAsStrings: [String] {
        var result: [String] = []
        for item in block.sub?.last?.sub?.last?.sub ?? [] {
            guard let name = generalName(of: item) else {
                continue
            }
            result.append(name)
        }
        return result
    }
    
    func generalName(of item: ASN1Object) -> String? {
        guard let nameType = item.identifier?.tagNumber().rawValue else {
            return nil
        }
        switch nameType {
        case 0:
            if let name = item.sub?.last?.sub?.last?.value as? String {
                return name
            }
        case 1, 2, 6:
            if let name = item.value as? String {
                return name
            }
        case 4:
            if let sequence = item.sub(0) {
                return ASN1DistinguishedNameFormatter.string(from: sequence)
            }
        case 7:
            if let ip = item.value as? Data {
                return ip.map({ "\($0)" }).joined(separator: ".")
            }
        case 8:
            if let value = item.value as? String, var data = value.data(using: .utf8) {
                let oid = ASN1DERDecoder.decodeOid(contentData: &data)
                return oid
            }
        default:
            return nil
        }
        return nil
    }
}
