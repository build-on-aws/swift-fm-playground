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

// import Hummingbird
// import HummingbirdTesting
// import Logging
// import XCTest // FIXME swift6 testing

// @testable import App

// final class AppTests: XCTestCase {
//     struct TestArguments: AppArguments {
//         let hostname = "127.0.0.1"
//         let port = 0
//         let logLevel: Logger.Level? = .trace
//     }

//     func testApp() async throws {
//         let args = TestArguments()
//         let app = try await buildApplication(args)

//         try await app.test(.router) { client in
//             try await client.execute(uri: "/health", method: .get) { response in
//                 XCTAssertEqual(response.body, ByteBuffer(string: "I am healthy!"))
//             }

//             try await client.execute(uri: "/foundation-models", method: .get) { response in
//                 XCTAssertEqual(response.status, .ok)
//             }
//         }
//     }
// }
