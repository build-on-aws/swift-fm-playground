# SwiftBedrockService

## How to add a new model?

As an example we will add the Claude 3 Haiku to the exting Anthropic family of models. 

### 1. Create BedrockModel in `AnthropicBedrockModels.swift`

In `backend/Sources/SwiftBedrockTypes/Anthropic/AnthropicBedrockModels.swift` add a line with the correct modelId, family and optionally the input and output modality (default is only text for both). Ensure the name you are choosing is unique and sufficiently descriptive (for example I add the version if multiple versions exist). 

```swift
public extension BedrockModel {
    static let instant: BedrockModel = BedrockModel(id: "anthropic.claude-instant-v1", family: .anthropic)
    static let claudev1: BedrockModel = BedrockModel(id: "anthropic.claude-v1", family: .anthropic)
    static let claudev2: BedrockModel = BedrockModel(id: "anthropic.claude-v2", family: .anthropic)
    static let claudev2_1: BedrockModel = BedrockModel(id: "anthropic.claude-v2:1", family: .anthropic)

    // add this line
    public static let claudev3_haiku: BedrockModel = BedrockModel(
        id: "anthropic.claude-3-haiku-20240307-v1:0", family: .anthropic,
        inputModality: [.text, .image])
}
```

### 2. Add model to initializer
In `backend/Sources/SwiftBedrockTypes/BedrockModel.swift` go to the failable raw value initializer and add the model to the switch statement. 

```swift
public init?(rawValue: String) {
    switch rawValue {
    case BedrockModel.claudev1.id:
        self = BedrockModel.claudev1 
    case BedrockModel.claudev2.id:
        self = BedrockModel.claudev2
    case BedrockModel.claudev2_1.id:
        self = BedrockModel.claudev2_1
    
    // add these two lines
    case BedrockModel.claudev3_haiku.id:
        self = BedrockModel.claudev3_haiku
    
    // ... 
    default:
        return nil
    }
}
```

You can now use your new model! 

## How to add a new model family?

As an example we will add the DeepSeek family with the DeepSeek-R1 model. 

### 1. Add modelFamily
In the enum in `backend/Sources/SwiftBedrockTypes/ModelFamily.swift`

```swift
public enum ModelFamily: Sendable {
    case anthropic
    case titan
    case nova
    case meta
    case deepseek   // add family here

    public var description: String {
        switch self {
        case .anthropic: return "anthropic"
        case .titan: return "titan"
        case .nova: return "nova"
        case .meta: return "meta"
        case .deepseek: return "deepseek"   // and also here
        }
    }
}
```
### 2. Create model family directory
Create the `backend/Sources/SwiftBedrockTypes/DeepSeek` directory with the following three files: `DeepSeekBedrockModels.swift`, `DeepSeekRequestBody.swift`, `DeepSeekResponseBody.swift`. 

### 3. Create BedrockModel in `DeepSeekBedrockModels.swift`
In the `backend/Sources/SwiftBedrockTypes/DeepSeek/DeepSeekBedrockModels.swift` file create the public extension to BedrockModel and add all the models you want to implement with the correct modelId, the modelFamily you just created and if necessary the input and/or output modality (defaults to `.text` for both). 

```swift
import Foundation

public extension BedrockModel {
    static let deepseek_r1_v1: BedrockModel = BedrockModel(id: "deepseek.r1-v1:0", family: .deepseek)
}
```

### 4. Add model to initializer

In `backend/Sources/SwiftBedrockTypes/BedrockModel.swift` go to the failable raw value initializer and add the model to the switch statement. 

```swift
public init?(rawValue: String) {
    switch rawValue {
    // ... 
    
    // add these lines
    case BedrockModel.deepseek_r1_v1.id:
        self = BedrockModel.deepseek_r1_v1
    
    // ... 
    default:
        return nil
    }
}
```

### 5. Create `DeepSeekRequestBody`
In the `backend/Sources/SwiftBedrockTypes/DeepSeek/DeepSeekRequestBody.swift` file create a struct that reflects exactly how the body of the request for an invokeModel call to this family should look. For the DeepSeek a request looks like this: 
```json
{
    "inferenceConfig": {
        "max_tokens": 512
    },
    "messages": [
        {
        "role": "user",
        "content": "this is where you place your input text"
        }
    ]
}
```
This means the `DeepSeekRequestBody` will be defined like so: 

```swift
public struct DeepSeekRequestBody: BedrockBodyCodable {
    let inferenceConfig: InferenceConfig
    let messages: [Message]

    public init(prompt: String, maxTokens: Int, temperature: Double) {
        self.inferenceConfig = InferenceConfig(max_tokens: maxTokens)
        self.messages = [Message(role: .user, content: prompt)]
    }

    struct InferenceConfig: Codable {
        let max_tokens: Int
    }

    struct Message: Codable {
        let role: Role
        let content: String
    }
}
```

Make sure to add the public initializer with parameters `prompt`, `maxTokens` and `temperature` to comply to the `BedrockBodyCodable` protocol. 

### 6. Create `DeepSeekResponseBody`
Based on the structure of the response body the `DeekSeekResponseBody` struct has to be created. 
```json
// TODO
```

```swift
public struct DeepSeekResponseBody: ContainsTextCompletion {
    // TODO 

    public func getTextCompletion() throws -> TextCompletion {
        // TODO
    }
}
```

Make sure to add the `getTextCompletion` method to extract the completion from the response body and to comply to the `ContainsTextCompletion` protocol.

### 7. Add request and response body to `BedrockRequest` and to `BedrockResponse` respectively

In `backend/Sources/SwiftBedrockService/BedrockRequest.swift` add the new model family to the correct private initializer. In this case, as the family only contains one model that only does text completion, only one initializer has to be adapted

```swift
private init(
    model: BedrockModel,
    prompt: String,
    maxTokens: Int,
    temperature: Double
) throws {
    // ... 
    switch model.family {
    
    // Add this code
    case .deepseek:
        body = DeepSeekRequestBody(
            prompt: prompt,
            maxTokens: maxTokens,
            temperature: temperature
        )
    
    // ...
    default:
        throw SwiftBedrockError.invalidModel(model.id)
    }
    self.init(model: model, body: body)
}
```

In `backend/Sources/SwiftBedrockService/BedrockResponse.swift` add the new model family to the switch statement.

```swift
public init(body data: Data, model: BedrockModel) throws {
    do {
        var body: ContainsTextCompletion
        let decoder = JSONDecoder()
        switch model.family {
        
        // Add this code
        case .deepseek:
            body = try decoder.decode(DeepSeekResponseBody.self, from: data)
        
        // ... 
        default:
            throw SwiftBedrockError.invalidModel(model.id)
        }
        self.init(model: model, body: body)
    } catch {
        throw SwiftBedrockError.invalidResponseBody(data)
    }
}
```