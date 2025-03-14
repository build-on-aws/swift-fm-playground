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

public struct AnthropicResponseBody: ContainsTextCompletion {
    let id: String
    let type: String
    let role: String
    let model: String
    let content: [Content]
    let stop_reason: String
    let stop_sequence: String?
    let usage: Usage

    public func getTextCompletion() throws -> TextCompletion {
        guard let completion = self.content[0].text else {
            throw SwiftBedrockError.completionNotFound("AnthropicResponseBody: content[0].text is nil")
        }
        return TextCompletion(completion)
    }

    struct Content: Codable {
        let type: String
        let text: String?
        let thinking: String?
    }

    struct Usage: Codable {
        let input_tokens: Int
        let output_tokens: Int
    }
}
