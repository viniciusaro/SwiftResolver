# SwiftResolver
Dependency injection framework for Swift.

## Usage
```swift
container.register { MyService() as Service }
...
let service: Service = container.resolve()
```

You can find more detailed use cases in the [wiki](https://github.com/viniciusaro/SwiftResolver/wiki) page

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
Later, when resolving, an identifier of the implementation can be passed as parameter to obtain the instance with the correct configuration.

```swift
enum MyServices: String {
    case mock
    case live
}

container.register { MyService(requestProvider: liveRequestProvider) as Service }.tag(MyServices.live)
container.register { MyService(requestProvider: mockRequestProvider) as Service }.tag(MyServices.mock)
...
let service: Service = container.resolve(MyServices.live)
```

## Thread Safety

SwiftResolver is thread safe. This means you can register/resolve in different threads. 

However, this is not a good practice since resolving instances that are not registered yet results in a `fatalError`.

Using an AppContainer as described in the [wiki](https://github.com/viniciusaro/SwiftResolver/wiki/Project-Setup) page, with a one time registration process that happens in the application start is recommended.

## References
* [Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)
* [Dip](https://github.com/AliSoftware/Dip)
