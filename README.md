# SwiftResolver
Dependency injection framework for Swift.

## Requirements
For Swift 4.0 see `swift-4` branch or `1.0.2-swift4` tag.
Some generics issues causes compiler error for ambiguity as shown here [https://bugs.swift.org/browse/SR-6108](https://bugs.swift.org/browse/SR-6108)

## Usage
```swift
container.register { MyService() as Service }
...
let service: Service = container.resolve()
```

## Instalation
```ruby
pod 'SwiftResolver'
```

## Improvements
- Use Mirror type to register all implemented protocols of a given type
- Create a mechanism to resolve different instances for the same type.

## References
[Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)
