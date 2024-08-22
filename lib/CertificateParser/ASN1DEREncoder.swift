//
//  ASN1DEREncoder.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

public class ASN1DEREncoder {
    public static func encodeSequence(content: Data) -> Data {
        var encoded = Data()
        encoded.append(ASN1Type.constructedTag | ASN1Type.Tag.sequence.rawValue)
        encoded.append(self.contentLength(of: content.count))
        encoded.append(content)
        return encoded
    }

    private static func contentLength(of size: Int) -> Data {
        if size >= 128 {
            var lenBytes = self.byteArray(from: size)
            while lenBytes.first == 0 { lenBytes.removeFirst() }
            let len: UInt8 = 0x80 | UInt8(lenBytes.count)
            return Data([len] + lenBytes)
        } else {
            return Data([UInt8(size)])
        }
    }

    private static func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
        return withUnsafeBytes(of: value.bigEndian, Array.init)
    }
}

extension Data {
    public var derEncodedSequence: Data {
        return ASN1DEREncoder.encodeSequence(content: self)
    }
}
