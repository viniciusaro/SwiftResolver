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
container.register(MyService.init).as(ServiceProtocol.self)
container.register(OtherService.init).as(ServiceProtocol.self)
...
let service: ServiceProtocol = container.resolve(MyService.self) // instance of MyService is returned here
```

## Multiple Configurations

You can register multiple implementations of the same object with different configurations.
Later, when resolving, an identifier of the implementation can be passed as parameter to obtain the correct implementation type.

```swift
enum MyServices: String {
  case mock
  case live
}

container.register { MyService(requestProvider: liveRequestProvider) }.tag(MyServices.live)
container.register { MyService(requestProvider: mockRequestProvider) }.tag(MyServices.mock)
...
let service: Service = container.resolve(MyServices.live)
```

## References
* [Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)
* [Dip](https://github.com/AliSoftware/Dip)
