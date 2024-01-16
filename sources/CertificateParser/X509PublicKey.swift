//
//  X509PublicKey.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

public class X509PublicKey {

    let pkBlock: ASN1Object

    init(pkBlock: ASN1Object) {
        self.pkBlock = pkBlock
    }

    public var algOid: String? {
        return pkBlock.sub(0)?.sub(0)?.value as? String
    }

    public var algName: String? {
        return OID.description(of: algOid ?? "")
    }

    public var algParams: String? {
        return pkBlock.sub(0)?.sub(1)?.value as? String
    }
    
    public var derEncodedKey: Data? {
        return pkBlock.rawValue?.derEncodedSequence
    }

    public var key: Data? {
        guard
            let algOid = algOid,
            let oid = OID(rawValue: algOid),
            let keyData = pkBlock.sub(1)?.value as? Data else {
                return nil
        }

        switch oid {
        case .ecPublicKey:
            return keyData

        case .rsaEncryption:
            guard let publicKeyAsn1Objects = (try? ASN1DERDecoder.decode(data: keyData)) else {
                return nil
            }
            guard let publicKeyModulus = publicKeyAsn1Objects.first?.sub(0)?.value as? Data else {
                return nil
            }
            return publicKeyModulus

        default:
            return nil
        }
    }
}
