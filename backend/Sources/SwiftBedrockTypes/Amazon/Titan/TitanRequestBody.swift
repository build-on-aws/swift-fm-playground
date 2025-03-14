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

public struct TitanRequestBody: BedrockBodyCodable {
    let inputText: String
    let textGenerationConfig: TextGenerationConfig

    public init(prompt: String, maxTokens: Int, temperature: Double) {
        self.inputText = prompt
        self.textGenerationConfig = TextGenerationConfig(
            maxTokenCount: maxTokens,
            temperature: temperature
        )
    }

    public struct TextGenerationConfig: Codable {
        let maxTokenCount: Int
        let temperature: Double
    }
}
