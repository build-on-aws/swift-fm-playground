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
import Hummingbird
import SwiftBedrockService
import SwiftBedrockTypes

extension TextCompletion: ResponseCodable {}

struct TextCompletionInput: Codable {
    let prompt: String
    let maxTokens: Int?
    let temperature: Double?
}

struct ImageGenerationInput: Codable {
    let prompt: String
    let stylePreset: String?
    let referenceImagePath: String?

    init(prompt: String, stylePreset: String? = "") {
        self.prompt = prompt
        self.stylePreset = stylePreset
        self.referenceImagePath = nil
    }

    init(prompt: String, referenceImagePath: String) {
        self.prompt = prompt
        self.stylePreset = ""
        self.referenceImagePath = referenceImagePath
    }
}

extension ImageGenerationOutput: ResponseCodable {}
