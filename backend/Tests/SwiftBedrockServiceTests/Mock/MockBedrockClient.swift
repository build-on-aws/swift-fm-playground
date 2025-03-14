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

@preconcurrency import AWSBedrock
import AWSClientRuntime
import AWSSDKIdentity
import Foundation
import SwiftBedrockService
import SwiftBedrockTypes

public struct MockBedrockClient: MyBedrockClientProtocol {
    public init() {}

    public func listFoundationModels(
        input: ListFoundationModelsInput
    ) async throws
        -> ListFoundationModelsOutput
    {
        ListFoundationModelsOutput(
            modelSummaries: [
                BedrockClientTypes.FoundationModelSummary(
                    modelId: "anthropic.claude-instant-v1",
                    modelName: "Claude Instant",
                    providerName: "Anthropic",
                    responseStreamingSupported: false
                ),
                BedrockClientTypes.FoundationModelSummary(
                    modelId: "anthropic.claude-instant-v2",
                    modelName: "Claude Instant 2",
                    providerName: "Anthropic",
                    responseStreamingSupported: true
                ),
                BedrockClientTypes.FoundationModelSummary(
                    modelId: "unknownID",
                    modelName: "Claude Instant 3",
                    providerName: nil,
                    responseStreamingSupported: false
                ),
            ])
    }
}
