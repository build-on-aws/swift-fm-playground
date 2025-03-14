//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Foundation Models Playground open source project
//
// Copyright (c) 2025 Amazon.com, Inc. or its affiliates
//                    and the Swift Foundation Models Playground project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Foundation Models Playground project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation

func getTimestamp() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd_hh-mm_a"
    return formatter.string(from: date)
}

func savePNGToDisk(data: Data, filePath: String) throws {
    let fileURL = URL(fileURLWithPath: filePath)

    do {
        try data.write(to: fileURL)
    } catch {
        fatalError("Unable to save data: \(error)")
    }
}

func loadPNGFromDisk(filePath: String) throws -> Data {
    let fileURL = URL(fileURLWithPath: filePath)

    guard FileManager.default.fileExists(atPath: filePath) else {
        fatalError("File not found at path: \(filePath)")
    }

    do {
        let data = try Data(contentsOf: fileURL)
        return data
    } catch {
        fatalError("Unable to load data: \(error)")
    }
}

func getImageAsBase64(filePath path: String) throws -> String {
    let imageData = try loadPNGFromDisk(filePath: path)
    return imageData.base64EncodedString()
}
