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

struct LlamaText: TextModality {
    func getName() -> String { "Llama Text Generation" }

    let parameters: TextGenerationParameters

    init(parameters: TextGenerationParameters) {
        self.parameters = parameters
    }

    func getParameters() -> TextGenerationParameters {
        parameters
    }

    func getTextRequestBody(
        prompt: String,
        maxTokens: Int?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        stopSequences: [String]?
    ) throws -> BedrockBodyCodable {
        guard topK == nil else {
            throw SwiftBedrockError.notSupported("TopK is not supported for Llama text completion")
        }
        guard stopSequences == nil else {
            throw SwiftBedrockError.notSupported("stopSequences is not supported for Llama text completion")
        }
        return LlamaRequestBody(
            prompt: prompt,
            maxTokens: maxTokens ?? parameters.maxTokens.defaultValue,
            temperature: temperature ?? parameters.temperature.defaultValue,
            topP: topP ?? parameters.topP.defaultValue
        )
    }

    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion {
        let decoder = JSONDecoder()
        return try decoder.decode(LlamaResponseBody.self, from: data)
    }
}
