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

extension VideoBlock {
    // init(from sdkVideoBlock: BedrockRuntimeClientTypes.VideoBlock) throws
    // func getSDKVideoBlock() throws -> BedrockRuntimeClientTypes.VideoBlock
}

extension VideoFormat {
    init(from sdkVideoFormat: BedrockRuntimeClientTypes.VideoFormat) throws {
        switch sdkVideoFormat {
        case .flv: self = .flv
        case .mkv: self = .mkv
        case .mov: self = .mov
        case .mp4: self = .mp4
        case .mpeg: self = .mpeg
        case .mpg: self = .mpg
        case .threeGp: self = .threeGp
        case .webm: self = .webm
        case .wmv: self = .wmv
        case .sdkUnknown(let unknownVideoFormat):
            throw BedrockServiceError.notImplemented(
                "VideoFormat \(unknownVideoFormat) is not implemented by BedrockRuntimeClientTypes"
            )
        // default: // in case new video formats get added to the sdk
        //     throw BedrockServiceError.notSupported(
        //         "VideoFormat \(sdkVideoFormat) is not supported by BedrockTypes"
        //     )
        }
    }

    func getSDKVideoFormat() throws -> BedrockRuntimeClientTypes.VideoFormat {
        switch self {
        case .flv: return .flv
        case .mkv: return .mkv
        case .mov: return .mov
        case .mp4: return .mp4
        case .mpeg: return .mpeg
        case .mpg: return .mpg
        case .threeGp: return .threeGp
        case .webm: return .webm
        case .wmv: return .wmv
        }
    }
}

extension VideoSource {
    init(from sdkVideoSource: BedrockRuntimeClientTypes.VideoSource) throws {
        switch sdkVideoSource {
        case .bytes(let data):
            self = .bytes(data.base64EncodedString())
        case .s3location(let sdkS3Location):
            self = .s3(try S3Location(from: sdkS3Location))
        case .sdkUnknown(let unknownVideoSource):
            throw BedrockServiceError.notImplemented(
                "VideoSource \(unknownVideoSource) is not implemented by BedrockRuntimeClientTypes"
            )
        }
    }

    func getSDKVideoSource() throws -> BedrockRuntimeClientTypes.VideoSource {
        switch self {
        case .bytes(let data):
            guard let sdkData = Data(base64Encoded: data) else {
                throw BedrockServiceError.decodingError(
                    "Could not decode video source from base64 string. String: \(data)"
                )
            }
            return .bytes(sdkData)
        case .s3(let s3Location):
            return .s3location(s3Location.getSDKS3Location())
        }
    }
}
