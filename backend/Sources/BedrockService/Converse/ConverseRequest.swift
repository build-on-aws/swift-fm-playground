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

@preconcurrency import AWSBedrockRuntime
import BedrockTypes
import Foundation

public struct ConverseRequest {
    let model: BedrockModel
    let messages: [Message]
    let inferenceConfig: InferenceConfig?
    // let toolConfig: ToolConfig?
    let systemPrompts: [String]?

    init(
        model: BedrockModel,
        messages: [Message] = [],
        maxTokens: Int?,
        temperature: Double?,
        topP: Double?,
        stopSequences: [String]?,
        systemPrompts: [String]?
            // tools: [Tool]
    ) {
        self.messages = messages
        self.model = model
        self.inferenceConfig = InferenceConfig(
            maxTokens: maxTokens,
            temperature: temperature,
            topP: topP,
            stopSequences: stopSequences
        )
        self.systemPrompts = systemPrompts
        // self.toolConfig = ToolConfig(tools: tools)
    }

    func getConverseInput() throws -> ConverseInput {
        let sdkInferenceConfig: BedrockRuntimeClientTypes.InferenceConfiguration?
        if inferenceConfig != nil {
            sdkInferenceConfig = inferenceConfig!.getSDKInferenceConfig()
        } else {
            sdkInferenceConfig = nil
        }
        return ConverseInput(
            inferenceConfig: sdkInferenceConfig,
            messages: try getSDKMessages(),
            modelId: model.id,
            system: getSDKSystemPrompts()
        )
    }

    private func getSDKMessages() throws -> [BedrockRuntimeClientTypes.Message] {
        try messages.map { try $0.getSDKMessage() }
    }

    private func getSDKSystemPrompts() -> [BedrockRuntimeClientTypes.SystemContentBlock]? {
        return systemPrompts?.map {
            BedrockRuntimeClientTypes.SystemContentBlock.text($0)
        }
    }

    struct InferenceConfig {
        let maxTokens: Int?
        let temperature: Double?
        let topP: Double?
        let stopSequences: [String]?

        func getSDKInferenceConfig() -> BedrockRuntimeClientTypes.InferenceConfiguration {
            let temperatureFloat: Float?
            if temperature != nil {
                temperatureFloat = Float(temperature!)
            } else {
                temperatureFloat = nil
            }
            let topPFloat: Float?
            if topP != nil {
                topPFloat = Float(topP!)
            } else {
                topPFloat = nil
            }
            return BedrockRuntimeClientTypes.InferenceConfiguration(
                maxTokens: maxTokens,
                stopSequences: stopSequences,
                temperature: temperatureFloat,
                topp: topPFloat
            )
        }
    }
}

public struct ToolConfig {
    // let toolChoice: ToolChoice?
    let tools: [Tool]
}

// public enum ToolChoice {
//     /// (Default). The Model automatically decides if a tool should be called or whether to generate text instead.
//     case auto(_)
//     /// The model must request at least one tool (no text is generated).
//     case any(_)
//     /// The Model must request the specified tool. Only supported by Anthropic Claude 3 models.
//     case tool(String)
// }
