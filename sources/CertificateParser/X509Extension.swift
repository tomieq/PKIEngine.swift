//
//  X509Extension.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

public class X509Extension {

    let block: ASN1Object

    required init(block: ASN1Object) {
        self.block = block
    }

    public var oid: String? {
        return block.sub(0)?.value as? String
    }

    public var name: String? {
        return OID.description(of: oid ?? "")
    }

    public var isCritical: Bool {
        if block.sub?.count ?? 0 > 2 {
            return block.sub(1)?.value as? Bool ?? false
        }
        return false
    }

    public var value: Any? {
        if let valueBlock = block.sub?.last {
            return firstLeafValue(block: valueBlock)
        }
        return nil
    }

    var valueAsBlock: ASN1Object? {
        return block.sub?.last
    }

    var valueAsStrings: [String] {
        var result: [String] = []
        for item in block.sub?.last?.sub?.last?.sub ?? [] {
            if let name = item.value as? String {
                result.append(name)
            }
        }
        return result
    }
}
