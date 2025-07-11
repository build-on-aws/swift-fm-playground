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

import AWSSDKIdentity
import Logging
import SmithyIdentity

/// Represent the authentication type for the Bedrock service
/// - `default`: Use the default AWS credential provider chain (see https://docs.aws.amazon.com/sdkref/latest/guide/standardized-credentials.html)
/// - `profile`: Use a specific profile name from the AWS credentials file. This works for application that runs on machines with AWS CLI configured, such as a server or your laptop. The application must not be sandboxed and have access to the credentials file.
/// - `sso`: Use SSO authentication with a specific profile name.`aws sso --profile <profile_name> login` must be done before running the application. This works for application that runs on machines with AWS CLI configured, such as a server or your laptop. The application must not be sandboxed and have access to the credentials file.
/// - `webIdentity`: Use a web identity token (JWT) to assume an IAM role. This is useful for applications running on iOS, tvOS or macOS where you cannot use the AWS CLI. Typically, the application authenticates the user with an external Identity provider (such as Sign In with Apple or Login With Google) and receives a JWT token. The application then uses this token to assume an IAM role and receive temporary AWS credentials. Some additional configuration is required on your AWS account to allow this. See https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html for more information. If you use Sign In With Apple, read https://docs.aws.amazon.com/sdk-for-swift/latest/developer-guide/apple-integration.html for more information.
///      Because `webidentity` is often used by application presenting a user interface. This method of authentication allows you to pass an optional closure that will be called when the credentials are retrieved. This is useful for updating the UI or notifying the user. The closure is called on the main (UI) thread.
/// - `static`: Use static AWS credentials. We strongly recommend to not use this option in production. This might be useful in some rare cases when testing and debugging.
/// - `apiKey`: Use an API key to authenticate. This is useful for applications that do not require full AWS credentials and only need to access specific APIs. The API key is passed as a string. API Keys are generated in the AWS console.
public enum BedrockAuthentication: Sendable, CustomStringConvertible {
    case `default`
    case profile(profileName: String = "default")
    case sso(profileName: String = "default")
    case webIdentity(token: String, roleARN: String, region: Region, notification: @Sendable () -> Void = {})
    case `static`(accessKey: String, secretKey: String, sessionToken: String)
    case apiKey(key: String)

    public var description: String {
        switch self {
        case .default:
            return "default"
        case .profile(let profileName):
            return "profile: \(profileName)"
        case .sso(let profileName):
            return "sso: \(profileName)"
        case .webIdentity(let token, let roleARN, let region, _):
            return "webIdentity: \(redactingSecret(secret: token)), roleARN: \(roleARN), region: \(region)"
        case .static(let accessKey, let secretKey, _):
            return "static: \(accessKey), secretKey: \(redactingSecret(secret: secretKey))"
        case .apiKey(let key):
            return "apiKey: \(redactingSecret(secret: key))"
        }
    }
    private func redactingSecret(secret: String) -> String {
        "\(secret.prefix(min(3, secret.count)))... *** shuuut, it's a secret ***"
    }

    /// Creates an AWS credential identity resolver depending on the authentication parameter.
    /// - Parameters:
    ///     - authentication: The authentication type to use
    /// - Returns: An optional AWS credential identity resolver. A nil return value means that the default AWS credential provider chain will be used or that the authentication type does not require a specific resolver (like `apiKey`).
    ///
    func getAWSCredentialIdentityResolver(
        logger: Logger
    ) async throws -> (any SmithyIdentity.AWSCredentialIdentityResolver)? {

        switch self {
        case .default, .apiKey(_):
            return nil  //TODO should we throw an error when apiKey is used ?
        case .profile(let profileName):
            return try? ProfileAWSCredentialIdentityResolver(profileName: profileName)
        case .sso(let profileName):
            return try? SSOAWSCredentialIdentityResolver(profileName: profileName)
        case .webIdentity(let token, let roleARN, let region, let notification):
            return try await webIdentityCredentialResolver(
                withWebIdentity: token,
                logger: logger,
                roleARN: roleARN,
                region: region,
                notify: notification
            )
        case .static(let accessKey, let secretKey, let sessionToken):
            logger.info("Using static AWS credentials. This is not recommended for production.")
            let creds = AWSCredentialIdentity(accessKey: accessKey, secret: secretKey, sessionToken: sessionToken)
            return StaticAWSCredentialIdentityResolver(creds)
        }
    }

    /// Creates a BearerTokenIdentityResolver depending on the authentication parameter.
    /// - Returns: An optional BearerTokenIdentityResolver. A nil return value means that the authentication type requires an AWSCredentialsProvider instead (like `default`, `profile`, `sso`, `webIdentity`, or `static`).
    /// - Note: Only `apiKey` authentication uses BearerTokenIdentityResolver.
    func getBearerTokenIdentityResolver(logger: Logger) -> (any SmithyIdentity.BearerTokenIdentityResolver)? {
        guard case .apiKey(let key) = self else {
            return nil  // Only apiKey authentication uses BearerTokenIdentityResolver
        }

        // Create a StaticBearerTokenIdentityResolver with the provided API key
        let identity = BearerTokenIdentity(token: key)
        return StaticBearerTokenIdentityResolver(token: identity)
    }
}
