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
import Foundation
import SwiftBedrockTypes

public struct BedrockResponse {
    let model: BedrockModel
    let contentType: String
    let body: ContainsTextCompletion

    private init(model: BedrockModel, contentType: String = "application/json", body: ContainsTextCompletion) {
        self.model = model
        self.contentType = contentType
        self.body = body
    }

    /// Creates a BedrockResponse from raw response data
    /// - Parameters:
    ///   - data: The raw response data from the Bedrock service
    ///   - model: The Bedrock model that generated the response
    /// - Throws: SwiftBedrockError.invalidModel if the model is not supported
    ///          SwiftBedrockError.invalidResponseBody if the response cannot be decoded
    public init(body data: Data, model: BedrockModel) throws {
        do {
            var body: ContainsTextCompletion
            let decoder = JSONDecoder()
            switch model.family {
            case .anthropic:
                body = try decoder.decode(AnthropicResponseBody.self, from: data)
            case .titan:
                body = try decoder.decode(TitanResponseBody.self, from: data)
            case .nova:
                body = try decoder.decode(NovaResponseBody.self, from: data)
            case .deepseek:
                body = try decoder.decode(DeepSeekResponseBody.self, from: data)
            default:
                throw SwiftBedrockError.invalidModel(model.id)
            }
            self.init(model: model, body: body)
        } catch {
            throw SwiftBedrockError.invalidResponseBody(data)
        }
    }

    /// Extracts the text completion from the response body
    /// - Returns: The text completion from the response
    /// - Throws: SwiftBedrockError.decodingError if the completion cannot be extracted
    public func getTextCompletion() throws -> TextCompletion {
        do {
            return try body.getTextCompletion()
        } catch {
            throw SwiftBedrockError.decodingError(
                "Something went wrong while decoding the request body to find the completion: \(error)"
            )
        }
    }
}
