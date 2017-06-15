# SwiftResolver
Dependency injection framework for Swift.

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
