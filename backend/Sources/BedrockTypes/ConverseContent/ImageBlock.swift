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

public struct ImageBlock: Codable {
    public let format: ImageFormat
    public let source: String  // 64 encoded

    public init(format: ImageFormat, source: String) {
        self.format = format
        self.source = source
    }
}

public enum ImageFormat: Codable {
    case gif
    case jpeg
    case png
    case webp
}
