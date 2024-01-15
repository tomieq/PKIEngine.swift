//
//  Shell.swift
//
//
//  Created by Tomasz on 15/01/2024.
//

import Foundation

struct Shell {
    @discardableResult
    func exec(_ command: String) -> String {
//        Logger.v("Invoke \(command)")
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        return output.trimmingCharacters(in: .newlines)
    }
}
