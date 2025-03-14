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

public struct BedrockModel: Equatable, Hashable, Sendable, RawRepresentable {
    public var rawValue: String { id }
    public typealias RawValue = String

    public var id: String
    public let family: ModelFamily
    public let inputModality: [ModelModality]
    public let outputModality: [ModelModality]

    /// Creates a new BedrockModel instance
    /// - Parameters:
    ///   - id: The unique identifier for the model
    ///   - family: The model family this model belongs to
    ///   - inputModality: Array of supported input modalities (defaults to [.text])
    ///   - outputModality: Array of supported output modalities (defaults to [.text])
    public init(
        id: String,
        family: ModelFamily,
        inputModality: [ModelModality] = [.text],
        outputModality: [ModelModality] = [.text]
    ) {
        self.id = id
        self.family = family
        self.inputModality = inputModality
        self.outputModality = outputModality
    }

    /// Creates a BedrockModel instance from a raw string value
    /// - Parameter rawValue: The model identifier string
    /// - Returns: The corresponding BedrockModel instance, or nil if the identifier is not recognized
    public init?(rawValue: String) {
        // If the rawValue is an ARN for an inference profile
        if rawValue.starts(with: "arn:aws:bedrock:") {
            if rawValue.contains("deepseek") {
                self.init(id: rawValue, family: .deepseek)
                return
            }
            // TODO: Add other model families as needed
        }
        switch rawValue {
        case BedrockModel.instant.id:
            self = BedrockModel.instant
        case BedrockModel.claudev1.id:
            self = BedrockModel.claudev1
        case BedrockModel.claudev2.id:
            self = BedrockModel.claudev2
        case BedrockModel.claudev2_1.id:
            self = BedrockModel.claudev2_1
        case BedrockModel.claudev3_haiku.id:
            self = BedrockModel.claudev3_haiku
        case BedrockModel.claudev3_5_haiku.id:  // FIXME: ARN
            self = BedrockModel.claudev3_5_haiku
        // case BedrockModel.claudev3_5_sonnet_v2.id:
        //     self = BedrockModel.claudev3_5_sonnet_v2
        case BedrockModel.titan_text_g1_premier.id:
            self = BedrockModel.titan_text_g1_premier
        case BedrockModel.titan_text_g1_express.id:
            self = BedrockModel.titan_text_g1_express
        case BedrockModel.titan_text_g1_lite.id:
            self = BedrockModel.titan_text_g1_lite
        case BedrockModel.nova_micro.id:
            self = BedrockModel.nova_micro
        case BedrockModel.titan_image_g1_v2.id:
            self = BedrockModel.titan_image_g1_v2
        case BedrockModel.titan_image_g1_v1.id:
            self = BedrockModel.titan_image_g1_v1
        case BedrockModel.nova_canvas.id:
            self = BedrockModel.nova_canvas
        case BedrockModel.deepseek_r1_v1.id:
            self = BedrockModel.deepseek_r1_v1
        default:
            return nil
        }
    }

    /// Checks if the model supports specific input and output modalities
    /// - Parameters:
    ///   - inputs: The required input modalities
    ///   - outputs: The required output modalities
    /// - Returns: True if the model supports all specified modalities
    public func supports(input: [ModelModality], output: [ModelModality]) -> Bool {
        input.allSatisfy { inputModality.contains($0) } && output.allSatisfy { outputModality.contains($0) }
    }

    /// Checks if the model supports specific input and output modalities
    /// - Parameters:
    ///   - input: The required input modality
    ///   - output: The required output modality
    /// - Returns: True if the model supports the specified modalities
    public func supports(input: ModelModality, output: ModelModality) -> Bool {
        inputModality.contains(input) && outputModality.contains(output)
    }

    public var description: String {
        "BedrockModel(id: \(id), family: \(family), input: \(inputModality), output: \(outputModality))"
    }
}
