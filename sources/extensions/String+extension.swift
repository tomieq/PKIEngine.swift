//
//  String+extension.swift
//
//
//  Created by Tomasz on 16/01/2024.
//

import Foundation

extension String {
    func chunked(by chunkSize: Int) -> [String] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            self.subString($0, Swift.min($0 + chunkSize, self.count))
        }
    }
}

extension String {
    public func subString(_ from: Int, _ to: Int) -> String {
        if self.count < to {
            return self
        }

        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to)

        let range = start..<end
        return String(self[range])
    }
}
