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

public struct ModelInfo: Codable {
    let modelName: String
    let providerName: String
    let modelId: String

    public init(modelName: String, providerName: String, modelId: String) {
        self.modelName = modelName
        self.providerName = providerName
        self.modelId = modelId
    }
}
