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

public struct NovaRequestBody: BedrockBodyCodable {
    let inferenceConfig: InferenceConfig
    let messages: [Message]

    public init(prompt: String, maxTokens: Int, temperature: Double) {
        self.inferenceConfig = InferenceConfig(max_new_tokens: maxTokens)
        self.messages = [Message(role: .user, content: [Content(text: prompt)])]
    }

    public struct InferenceConfig: Codable {
        let max_new_tokens: Int
    }

    public struct Message: Codable {
        let role: Role
        let content: [Content]
    }

    public struct Content: Codable {
        let text: String
    }
}
