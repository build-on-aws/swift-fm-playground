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

public enum ModelFamily: Sendable {
    case anthropic
    case titan
    case nova
    case meta
    case deepseek

    public var description: String {
        switch self {
        case .anthropic: return "anthropic"
        case .titan: return "titan"
        case .nova: return "nova"
        case .meta: return "meta"
        case .deepseek: return "deepseek"
        }
    }
}
