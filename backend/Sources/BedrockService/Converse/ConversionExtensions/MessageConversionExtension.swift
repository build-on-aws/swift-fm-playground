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

extension Message {

    init(from sdkMessage: BedrockRuntimeClientTypes.Message) throws {
        guard let sdkRole = sdkMessage.role else {
            throw BedrockServiceError.decodingError("Could not extract role from BedrockRuntimeClientTypes.Message")
        }
        guard let sdkContent = sdkMessage.content else {
            throw BedrockServiceError.decodingError("Could not extract content from BedrockRuntimeClientTypes.Message")
        }
        let content: [Content] = try sdkContent.map { try Content(from: $0) }
        self = Message(from: try Role(from: sdkRole), content: content)
    }

    func getSDKMessage() throws -> BedrockRuntimeClientTypes.Message {
        let contentBlocks: [BedrockRuntimeClientTypes.ContentBlock] = try content.map {
            content -> BedrockRuntimeClientTypes.ContentBlock in
            return try content.getSDKContentBlock()
        }
        return BedrockRuntimeClientTypes.Message(
            content: contentBlocks,
            role: role.getSDKConversationRole()
        )
    }
}
