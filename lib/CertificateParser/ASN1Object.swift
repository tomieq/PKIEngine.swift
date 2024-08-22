//
//  ASN1Object.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

public class ASN1Object: CustomStringConvertible {
    /// This property contains the DER encoded object
    public var rawValue: Data?

    /// This property contains the decoded Swift object whenever is possible
    public var value: Any?

    public var type: ASN1Type?

    var children: [ASN1Object]?

    public internal(set) weak var parent: ASN1Object?

    public func child(_ index: Int) -> ASN1Object? {
        if let child = self.children, index >= 0, index < child.count {
            return child[index]
        }
        return nil
    }

    public func findOid(_ oid: OID) -> ASN1Object? {
        return self.findOid(oid.rawValue)
    }

    public func findOid(_ oid: String) -> ASN1Object? {
        for child in self.children ?? [] {
            if child.type?.tag == .objectIdentifier {
                if child.value as? String == oid {
                    return child
                }
            } else {
                if let result = child.findOid(oid) {
                    return result
                }
            }
        }
        return nil
    }

    public var description: String {
        return self.printAsn1()
    }

    public var asString: String? {
        if let string = value as? String {
            return string
        }

        for item in self.children ?? [] {
            if let string = item.asString {
                return string
            }
        }

        return nil
    }

    fileprivate func printAsn1(insets: String = "") -> String {
        var output = insets
        output.append(self.type?.description.uppercased() ?? "")
        output.append(self.value != nil ? ": \(self.value!)" : "")
        if self.type?.typeClass() == .universal, self.type?.tag == .objectIdentifier {
            if let oidName = OID.description(of: value as? String ?? "") {
                output.append(" (\(oidName))")
            }
        }
        output.append(self.children != nil && self.children!.count > 0 ? " {" : "")
        output.append("\n")
        for item in self.children ?? [] {
            output.append(item.printAsn1(insets: insets + "    "))
        }
        output.append(self.children != nil && self.children!.count > 0 ? insets + "}\n" : "")
        return output
    }
}
