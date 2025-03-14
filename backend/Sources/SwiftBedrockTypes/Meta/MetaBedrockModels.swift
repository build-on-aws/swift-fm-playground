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
    public static var llama2_13b: BedrockModel { .init(id: "meta.llama2.13b", family: .meta) }
    public static var llama2_70b: BedrockModel { .init(id: "meta.llama2.70b", family: .meta) }
}
