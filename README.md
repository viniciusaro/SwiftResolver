# SwiftResolver
Dependency injection framework for Swift.

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

## Multiple Implementations of same Protocol

You can register multiple implementations of the same protocol in the same container.
Later, when resolving, the specific type of the implementation can be passed as parameter to obtain the correct implementation type.

```swift
container.register(MyService.init).as(Service.self)
...
let service: Service = container.resolve(MyService.self)
```

## Multiple Implementations of same Protocol

You can register multiple implementations of the same protocol in the same container.
Later, when resolving, the specific type of the implementation can be passed as parameter to obtain the correct implementation type.

```swift
container.register(MyService.init).as(Service.self)
...
let service: Service = container.resolve(MyService.self)
```

## References
[Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)
[Dip](https://github.com/AliSoftware/Dip)
