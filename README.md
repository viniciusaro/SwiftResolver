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

## Auto Injection
SwiftResolver also provides a way for injecting properties with generated initializers using [Sourcery](https://github.com/krzysztofzablocki/Sourcery):
For that to work add the following protocol conformance to the class/struct you want to auto inject properties:
```swift
final class MyClass: Injectable {
    ...
}
```
Then add the `/// sourcery: inject` comment to the properties you want to inject:
```swift
final class MyClass: Injectable {

    /// sourcery: inject
    let myDependency: MyDependencyType
    let myOtherDependency: MyOtherDependencyType

    public init(myDependency: MyDependencyType, myOtherDependency: MyOtherDependencyType) {
        self.myDependency = myDependency
        self.myOtherDependency = myOtherDependency
    }
}
```
The `SwiftResolverGenerated.swift` file will contain:
```swift
protocol Injectable {}

extension MyClass {
    convenience init(myOtherDependency: MyOtherDependencyType) {
        let myDependency: MyDependencyType = resolve()
        self.init(myDependency: myDependency, myOtherDependency: myOtherDependency)
    }
}
```
>  Every initializer of a class will be used as template to create the `convenience` ones. SwiftResolver will remove the parameters marked as injected from the initializer parameters and will keep the other ones. That means if the class contains any initializer with a parameter that is not injectable, the generated initializer will contain that parameter:

> Note that there's a call to a global `resolve` method. You need to implement this method to resolve all your dependencies.
> This will mostly be a call to a global container, just like:
```swift
func resolve<T>() -> T {
    return DefaultContainer.shared.resolve()
}
```
> To generate the files add a new `Run Script Phase` to your build phases and place it before any compiling phase.
```sh
${PODS_ROOT}/SwiftResolver/Scripts/swiftresolver.sh
```

## References
[Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)
