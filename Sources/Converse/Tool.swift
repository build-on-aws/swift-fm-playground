//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Bedrock Library open source project
//
// Copyright (c) 2025 Amazon.com, Inc. or its affiliates
//                    and the Swift Bedrock Library project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Bedrock Library project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

@preconcurrency import AWSBedrockRuntime
import Foundation
import Smithy

public struct Tool: Codable, CustomStringConvertible {
    public let name: String
    public let inputSchema: JSON
    public let toolDescription: String?

    public init(name: String, inputSchema: JSON, description: String? = nil) throws {
        guard !name.isEmpty else {
            throw BedrockLibraryError.invalidName("Tool name is not allowed to be empty")
        }
        guard name.contains(/[a-zA-Z0-9_-]+/) else {
            throw BedrockLibraryError.invalidName(
                "Tool name must consist of only lowercase letter, uppercase letters, digits, underscores and hyphens"
            )
        }
        self.name = name
        self.inputSchema = inputSchema
        self.toolDescription = description
    }

    public init(from sdkToolSpecification: BedrockRuntimeClientTypes.ToolSpecification) throws {
        guard let name = sdkToolSpecification.name else {
            throw BedrockLibraryError.decodingError(
                "Could not extract name from BedrockRuntimeClientTypes.ToolSpecification"
            )
        }
        guard let sdkInputSchema = sdkToolSpecification.inputSchema else {
            throw BedrockLibraryError.decodingError(
                "Could not extract inputSchema from BedrockRuntimeClientTypes.ToolSpecification"
            )
        }
        guard case .json(let smithyDocument) = sdkInputSchema else {
            throw BedrockLibraryError.decodingError(
                "Could not extract JSON from BedrockRuntimeClientTypes.ToolSpecification.inputSchema"
            )
        }
        let inputSchema = try smithyDocument.toJSON()
        self = try Tool(
            name: name,
            inputSchema: inputSchema,
            description: sdkToolSpecification.description
        )
    }

    public func getSDKToolSpecification() throws -> BedrockRuntimeClientTypes.ToolSpecification {
        BedrockRuntimeClientTypes.ToolSpecification(
            description: description,
            inputSchema: .json(try inputSchema.toDocument()),
            name: name
        )
    }

    // for CustomStringConvertible
    public var description: String {
        "Tool(name: \(name), description: \(toolDescription ?? "nil"))"
    }
}
