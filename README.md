# SwiftResolver
Dependency injection framework for Swift.

Dependency injection (DI) is a software design pattern that implements Inversion of Control (IoC) for resolving dependencies.
The pattern helps your app split into loosely-coupled components, which can be developed, tested and maintained more easily. 
SwiftResolver is powered by the Swift generic type system and first class functions to define dependencies of your app simply and fluently.

## Usage
```
container.register { MyService() as Service }
...
let service: MyService = container.resolve()
```

## Instalation
`pod 'SwiftResolver'`

## Improvements
- Use Mirror type to register all implemented protocols of a given type
- Create a mechanism to resolve different instances for the same type.

## References
[Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)
