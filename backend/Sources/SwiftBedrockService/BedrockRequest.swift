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

struct BedrockRequest {
    let model: BedrockModel
    let contentType: String
    let accept: String
    private let body: BedrockBodyCodable

    private init(
        model: BedrockModel,
        body: BedrockBodyCodable,
        contentType: String = "application/json",
        accept: String = "application/json"
    ) {
        self.model = model
        self.body = body
        self.contentType = contentType
        self.accept = accept
    }

    // MARK: text
    /// Creates a BedrockRequest for a text request with the specified parameters
    /// - Parameters:
    ///   - model: The Bedrock model to use
    ///   - prompt: The input text prompt
    ///   - maxTokens: Maximum number of tokens to generate (default: 300)
    ///   - temperature: Temperature for text generation (default: 0.6)
    /// - Returns: A configured BedrockRequest for a text request
    /// - Throws: SwiftBedrockError if the model doesn't support text output
    static func createTextRequest(
        model: BedrockModel,
        prompt: String,
        maxTokens: Int = 300,
        temperature: Double = 0.6
    ) throws -> BedrockRequest {
        try .init(model: model, prompt: prompt, maxTokens: maxTokens, temperature: temperature)
    }

    private init(
        model: BedrockModel,
        prompt: String,
        maxTokens: Int,
        temperature: Double
    ) throws {
        guard model.supports(input: .text, output: .text) else {
            throw SwiftBedrockError.invalidModel(
                "Modality of \(model.id) not as expected: input: \(model.inputModality), output: \(model.outputModality)"
            )
        }
        var body: BedrockBodyCodable
        switch model.family {
        case .anthropic:
            body = AnthropicRequestBody(
                prompt: prompt,
                maxTokens: maxTokens,
                temperature: temperature
            )
        case .titan:
            body = TitanRequestBody(
                prompt: prompt,
                maxTokens: maxTokens,
                temperature: temperature
            )
        case .nova:
            body = NovaRequestBody(
                prompt: prompt,
                maxTokens: maxTokens,
                temperature: temperature
            )
        case .deepseek:
            body = DeepSeekRequestBody(
                prompt: prompt,
                maxTokens: maxTokens,
                temperature: temperature
            )
        default:
            throw SwiftBedrockError.invalidModel(model.id)
        }
        self.init(model: model, body: body)
    }

    // MARK: text to image
    /// Creates a BedrockRequest for a text-to-image request with the specified parameters
    /// - Parameters:
    ///   - model: The Bedrock model to use for image generation
    ///   - prompt: The text description of the image to generate
    ///   - nrOfImages: The number of images to generate
    /// - Returns: A configured BedrockRequest for image generation
    /// - Throws: SwiftBedrockError if the model doesn't support text input or image output
    public static func createTextToImageRequest(
        model: BedrockModel,
        prompt: String,
        nrOfImages: Int
    ) throws -> BedrockRequest {
        try .init(model: model, prompt: prompt, nrOfImages: nrOfImages)
    }

    private init(model: BedrockModel, prompt: String, nrOfImages: Int) throws {
        guard model.supports(input: .text, output: .image) else {
            throw SwiftBedrockError.invalidModel(
                "Modality of \(model.id) not as expected: input: \(model.inputModality), output: \(model.outputModality)"
            )
        }
        var body: BedrockBodyCodable
        switch model.family {
        case .titan, .nova:
            body = AmazonImageRequestBody.textToImage(prompt: prompt, nrOfImages: nrOfImages)
        default:
            throw SwiftBedrockError.invalidModel(model.id)
        }
        self.init(model: model, body: body)
    }

    // MARK: image variation
    /// Creates a BedrockRequest for a request to generate variations of an existing image
    /// - Parameters:
    ///   - model: The Bedrock model to use for image variation generation
    ///   - prompt: The text description to guide the variation generation
    ///   - image: The base64-encoded string of the source image to create variations from
    ///   - similarity: A value between 0 and 1 indicating how similar the variations should be to the source image
    ///   - nrOfImages: The number of image variations to generate
    /// - Returns: A configured BedrockRequest for image variation generation
    /// - Throws: SwiftBedrockError if the model doesn't support text and image input, or image output
    public static func createImageVariationRequest(
        model: BedrockModel,
        prompt: String,
        image: String,
        similarity: Double,
        nrOfImages: Int
    ) throws -> BedrockRequest {
        try .init(model: model, prompt: prompt, image: image, similarity: similarity, nrOfImages: nrOfImages)
    }

    private init(
        model: BedrockModel,
        prompt: String,
        image: String,
        similarity: Double,
        nrOfImages: Int
    ) throws {
        guard model.supports(input: [.text, .image], output: [.image]) else {
            throw SwiftBedrockError.invalidModel(
                "Modality of \(model.id) not as expected: input: \(model.inputModality), output: \(model.outputModality)"
            )
        }
        var body: BedrockBodyCodable
        switch model.family {
        case .titan, .nova:
            body = AmazonImageRequestBody.imageVariation(
                prompt: prompt,
                referenceImage: image,
                similarity: similarity,
                nrOfImages: nrOfImages
            )
        default:
            throw SwiftBedrockError.invalidModel(model.id)
        }
        self.init(model: model, body: body)
    }

    /// Creates an InvokeModelInput instance for making a request to Amazon Bedrock
    /// - Returns: A configured InvokeModelInput containing the model ID, content type, and encoded request body
    /// - Throws: SwiftBedrockError.encodingError if the request body cannot be encoded to JSON
    public func getInvokeModelInput() throws -> InvokeModelInput {
        do {
            let jsonData: Data = try JSONEncoder().encode(self.body)
            return InvokeModelInput(
                accept: self.accept,
                body: jsonData,
                contentType: self.contentType,
                modelId: model.id
            )
        } catch {
            throw SwiftBedrockError.encodingError(
                "Something went wrong while encoding the request body to JSON for InvokeModelInput: \(error)"
            )
        }
    }

}
