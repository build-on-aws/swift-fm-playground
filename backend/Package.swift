// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HummingbirdBackend",  // FIXME: better name
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17)],
    products: [
        .executable(name: "App", targets: ["App"])  // FIXME: better name
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "1.2.45"),
        .package(url: "https://github.com/smithy-lang/smithy-swift", from: "0.118.0"),
        .package(url: "https://github.com/swiftlang/swift-testing", branch: "main"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.3"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .target(name: "BedrockService"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Hummingbird", package: "hummingbird"),
            ],
            path: "Sources/App"
        ),
        .target(
            name: "BedrockService",
            dependencies: [
                .target(name: "BedrockTypes"),
                .product(name: "AWSClientRuntime", package: "aws-sdk-swift"),
                .product(name: "AWSBedrock", package: "aws-sdk-swift"),
                .product(name: "AWSBedrockRuntime", package: "aws-sdk-swift"),
                .product(name: "Smithy", package: "smithy-swift"),
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "Sources/BedrockService"
        ),
        .target(
            name: "BedrockTypes",
            path: "Sources/BedrockTypes"
        ),
        .testTarget(
            name: "BedrockServiceTests",
            dependencies: [
                .target(name: "BedrockService"),
                .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/BedrockServiceTests"
        ),
        // .testTarget(name: "AppTests",
        //     dependencies: [
        //         .byName(name: "App"),
        //         .target(name: "SwiftBedrockService"),
        //         .product(name: "HummingbirdTesting", package: "hummingbird")
        //     ],
        //     path: "Tests/AppTests"
        // )
    ]
)
