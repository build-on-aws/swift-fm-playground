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

extension BedrockModel {
    public static let instant: BedrockModel = BedrockModel(
        id: "anthropic.claude-instant-v1",
        family: .anthropic
    )
    public static let claudev1: BedrockModel = BedrockModel(
        id: "anthropic.claude-v1",
        family: .anthropic
    )
    public static let claudev2: BedrockModel = BedrockModel(
        id: "anthropic.claude-v2",
        family: .anthropic
    )
    public static let claudev2_1: BedrockModel = BedrockModel(
        id: "anthropic.claude-v2:1",
        family: .anthropic
    )
    public static let claudev3_haiku: BedrockModel = BedrockModel(
        id: "anthropic.claude-3-haiku-20240307-v1:0",
        family: .anthropic,
        inputModality: [.text, .image]
    )

    // FIXME: inference profile issue
    // `Invocation of model ID anthropic.claude-3-5-haiku-20241022-v1:0 with on-demand throughput isn’t supported.
    // Retry your request with the ID or ARN of an inference profile that contains this model.`

    public static let claudev3_5_haiku: BedrockModel = BedrockModel(
        id: "anthropic.claude-3-5-haiku-20241022-v1:0",
        family: .anthropic
    )
    // public static let claudev3_5_sonnet_v2: BedrockModel = BedrockModel(
    //     id: "anthropic.claude-3-5-sonnet-20241022-v2:0", family: .anthropic,
    //     inputModality: [.text, .image], outputModality: [.text])
}
