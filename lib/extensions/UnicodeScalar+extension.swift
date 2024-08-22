//
//  File.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

enum UnicodeScalarError: Error {
    case illegalCharacter(String)
}

extension UnicodeScalar {
    func hex2byte() throws -> UInt8 {
        let value = self.value
        if value >= 48, value <= 57 {
            return UInt8(value - 48)
        } else if value >= 65, value <= 70 {
            return UInt8(value - 55)
        } else if value >= 97, value <= 102 {
            return UInt8(value - 87)
        }
        throw UnicodeScalarError.illegalCharacter("Sign \(value) is not valid hex number")
    }
}
