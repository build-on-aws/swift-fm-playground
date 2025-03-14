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

import Testing

@testable import SwiftBedrockService
@testable import SwiftBedrockTypes

@Suite("SwiftBedrockService Tests")
struct SwiftBedrockServiceTests {
    let bedrock: SwiftBedrock

    init() async throws {
        self.bedrock = try await SwiftBedrock(
            bedrockClient: MockBedrockClient(),
            bedrockRuntimeClient: MockBedrockRuntimeClient()
        )
    }

    // MARK: listModels

    @Test("List all models")
    func listModels() async throws {
        let models = try await bedrock.listModels()
        #expect(models.count == 2)
        #expect(models[0].modelId == "anthropic.claude-instant-v1")
        #expect(models[0].modelName == "Claude Instant")
        #expect(models[0].providerName == "Anthropic")
    }

    // MARK: completeText

    @Test(
        "Complete text using an implemented model",
        arguments: [
            BedrockModel.nova_micro,
            BedrockModel.titan_text_g1_lite,
            BedrockModel.titan_text_g1_express,
            BedrockModel.titan_text_g1_premier,
            BedrockModel.claudev1,
            BedrockModel.claudev2,
            BedrockModel.claudev2_1,
            BedrockModel.claudev3_haiku,
            BedrockModel.claudev3_5_haiku,
        ]
    )
    func completeTextWithValidModel(model: BedrockModel) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: model,
            maxTokens: 100,
            temperature: 0.5
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test(
        "Complete text using an invalid model",
        arguments: [
            // not implemented
            BedrockModel.llama2_13b,
            BedrockModel.llama2_70b,
            // not text generation
            BedrockModel.titan_image_g1_v1,
            BedrockModel.titan_image_g1_v2,
            BedrockModel.nova_canvas,
        ]
    )
    func completeTextWithInvalidModel(model: BedrockModel) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: model,
                temperature: 0.8
            )
        }
    }

    @Test("Complete text using a valid temperature", arguments: [0, 0.2, 0.6, 1])
    func completeTextWithValidTemperature(temperature: Double) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            temperature: temperature
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test("Complete text using an invalid temperature", arguments: [-2.5, -1, 1.00001, 2])
    func completeTextWithInvalidTemperature(temperature: Double) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_micro,
                temperature: temperature
            )
        }
    }

    @Test(
        "Complete text using a valid maxTokens",
        arguments: [1, 10, 100, 5000]
    )
    func completeTextWithValidMaxTokens(maxTokens: Int) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            maxTokens: maxTokens
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test(
        "Complete text using an invalid maxTokens",
        arguments: [0, -1, -2]
    )
    func completeTextWithInvalidMaxTokens(maxTokens: Int) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_micro,
                maxTokens: maxTokens
            )
        }
    }

    @Test(
        "Complete text using a valid prompt",
        arguments: [
            "This is a test", "!@#$%^&*()_+{}|:<>?", String(repeating: "test ", count: 1000),
        ]
    )
    func completeTextWithValidPrompt(prompt: String) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            prompt,
            with: BedrockModel.nova_micro,
            maxTokens: 200
        )
        #expect(completion.completion == "This is the textcompletion for: \(prompt)")
    }

    @Test(
        "Complete text using an invalid prompt",
        arguments: ["", " ", " \n  ", "\t"]
    )
    func completeTextWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                prompt,
                with: BedrockModel.nova_micro,
                maxTokens: 10
            )
        }
    }

    // MARK: generateImage

    @Test(
        "Generate image using an implemented model",
        arguments: [
            BedrockModel.titan_image_g1_v1,
            BedrockModel.titan_image_g1_v2,
            BedrockModel.nova_canvas,
        ]
    )
    func generateImageWithValidModel(model: BedrockModel) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            "This is a test",
            with: model
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image using an implemented model",
        arguments: [
            // not implemented
            BedrockModel.llama2_13b,
            BedrockModel.llama2_70b,
            // not image generation
            BedrockModel.nova_micro,
            BedrockModel.titan_text_g1_lite,
            BedrockModel.titan_text_g1_express,
            BedrockModel.titan_text_g1_premier,
            BedrockModel.claudev1,
            BedrockModel.claudev2,
            BedrockModel.claudev2_1,
            BedrockModel.claudev3_haiku,
            BedrockModel.claudev3_5_haiku,
        ]
    )
    func generateImageWithInvalidModel(model: BedrockModel) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                "This is a test",
                with: model,
                nrOfImages: 3
            )
        }
    }

    @Test(
        "Generate image using a valid nrOfImages",
        arguments: [1, 2, 3, 4, 5]
    )
    func generateImageWithValidNrOfImages(nrOfImages: Int) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            "This is a test",
            with: BedrockModel.nova_canvas,
            nrOfImages: nrOfImages
        )
        #expect(output.images.count == nrOfImages)
    }

    @Test(
        "Generate image using an invalid nrOfImages",
        arguments: [-2, 0, 6, 20]
    )
    func generateImageWithInvalidNrOfImages(nrOfImages: Int) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                "This is a test",
                with: BedrockModel.nova_canvas,
                nrOfImages: nrOfImages
            )
        }
    }

    @Test(
        "Generate image using a valid prompt",
        arguments: [
            "This is a test", "!@#$%^&*()_+{}|:<>?", String(repeating: "test ", count: 1000),
        ]
    )
    func generateImageWithValidPrompt(prompt: String) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            prompt,
            with: BedrockModel.nova_canvas,
            nrOfImages: 3
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image using an invalid prompt",
        arguments: ["", " ", " \n  ", "\t"]
    )
    func generateImageWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                prompt,
                with: BedrockModel.nova_canvas
            )
        }
    }

    // MARK: editImage

    @Test(
        "Generate image variation using an implemented model",
        arguments: [
            BedrockModel.titan_image_g1_v1,
            BedrockModel.titan_image_g1_v2,
            BedrockModel.nova_canvas,
        ]
    )
    func editImageWithValidModel(model: BedrockModel) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.editImage(
            image: mockBase64Image,
            prompt: "This is a test",
            with: model,
            nrOfImages: 3
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image variation using an invalid model",
        arguments: [
            // not implemented
            BedrockModel.llama2_13b,
            BedrockModel.llama2_70b,
            // not image variation
            BedrockModel.nova_micro,
            BedrockModel.titan_text_g1_lite,
            BedrockModel.titan_text_g1_express,
            BedrockModel.titan_text_g1_premier,
            BedrockModel.claudev1,
            BedrockModel.claudev2,
            BedrockModel.claudev2_1,
            BedrockModel.claudev3_haiku,
            BedrockModel.claudev3_5_haiku,
        ]
    )
    func editImageWithInvalidModel(model: BedrockModel) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.editImage(
                image: mockBase64Image,
                prompt: "This is a test",
                with: model,
                nrOfImages: 3
            )
        }
    }

    @Test(
        "Generate image variation using a valid nrOfImages",
        arguments: [1, 2, 3, 4, 5]
    )
    func editImageWithValidNrOfImages(nrOfImages: Int) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.editImage(
            image: mockBase64Image,
            prompt: "This is a test",
            with: BedrockModel.nova_canvas,
            nrOfImages: nrOfImages
        )
        #expect(output.images.count == nrOfImages)
    }

    @Test(
        "Generate image variation using an invalid nrOfImages",
        arguments: [-4, 0, 6, 20]
    )
    func editImageWithInvalidNrOfImages(nrOfImages: Int) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.editImage(
                image: mockBase64Image,
                prompt: "This is a test",
                with: BedrockModel.nova_canvas,
                nrOfImages: nrOfImages
            )
        }
    }

    @Test(
        "Generate image variation using a valid similarity",
        arguments: [0, 0.4, 1]
    )
    func editImageWithValidNr(similarity: Double) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.editImage(
            image: mockBase64Image,
            prompt: "This is a test",
            with: BedrockModel.nova_canvas,
            similarity: similarity,
            nrOfImages: 3
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image variation using an invalid similarity",
        arguments: [-4, -0.001, 1.1, 2]
    )
    func editImageWithInvalidNrOfImages(similarity: Double) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.editImage(
                image: mockBase64Image,
                prompt: "This is a test",
                with: BedrockModel.nova_canvas,
                similarity: similarity,
                nrOfImages: 3
            )
        }
    }

    @Test(
        "Generate image variation using a valid prompt",
        arguments: [
            "This is a test", "!@#$%^&*()_+{}|:<>?", String(repeating: "test ", count: 1000),
        ]
    )
    func editImageWithValidPrompt(prompt: String) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.editImage(
            image: mockBase64Image,
            prompt: prompt,
            with: BedrockModel.nova_canvas,
            similarity: 0.6
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image variation using an invalid prompt",
        arguments: ["", " ", " \n  ", "\t"]
    )
    func editImageWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: SwiftBedrockError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.editImage(
                image: mockBase64Image,
                prompt: prompt,
                with: BedrockModel.nova_canvas,
                similarity: 0.6
            )
        }
    }
}
