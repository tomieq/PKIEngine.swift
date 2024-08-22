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
        return self.block.child(0)?.value as? String
    }

    public var name: String? {
        return OID.description(of: self.oid ?? "")
    }

    public var isCritical: Bool {
        if self.block.children?.count ?? 0 > 2 {
            return self.block.child(1)?.value as? Bool ?? false
        }
        return false
    }

    public var value: Any? {
        if let valueBlock = block.children?.last {
            return firstLeafValue(in: valueBlock)
        }
        return nil
    }

    var valueAsBlock: ASN1Object? {
        return self.block.children?.last
    }

    var valueAsStrings: [String] {
        var result: [String] = []
        for item in self.block.children?.last?.children?.last?.children ?? [] {
            if let name = item.value as? String {
                result.append(name)
            }
        }
        return result
    }
}
