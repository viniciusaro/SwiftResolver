final class DependencyPool {
    private var factories: Atomic<[String: AnyFactory]> = Atomic([:])
    private var sharedInstances = InstancePool()
    private var singletonInstances = InstancePool()
    
    func sharedInstance<T>() -> T? {
        return self.sharedInstances.get()
    }
    
    func singletonInstance<T>() -> T? {
        return self.singletonInstances.get()
    }
    
    func registerShared<T>(instance: T) {
        self.sharedInstances.register(instance: instance)
    }
    
    func registerSingleton<T>(instance: T) {
        self.singletonInstances.register(instance: instance)
    }
    
    func clearShared() {
        self.sharedInstances.clear()
    }
    
    func instanceCountFor<T>(type: T.Type) -> Int {
        let identifier = String(describing: T.self)
        guard let factory = self.factories.value[identifier] else {
            return 0
        }
        return factory.instanceCount
    }
}

extension DependencyPool {
    func register<Factory: FactoryType>(_ factory: Factory) -> TypeSpecifier {
        self.internalRegister(factory)
        
        return TypeSpecifier(onRegister: { identifier in
            self.internalRegister(factory, specificIdentifier: identifier)
        })
    }
    
    private func internalRegister<Factory: FactoryType>(_ factory: Factory, specificIdentifier: String = "") {
        let elementTypeIdentifier = String(describing: Factory.Element.self).withoutTypeExtension
        let typeSpecificIdentifier = specificIdentifier.withoutTypeExtension
        let identifier = elementTypeIdentifier + typeSpecificIdentifier
        
        self.factories.mutate { $0[identifier] = factory.asAny() }
        if typeSpecificIdentifier.count > 0 {
            self.factories.mutate { $0[typeSpecificIdentifier] = factory.asAny() }
        }
    }
}

extension DependencyPool {
    func instance<T>() throws -> T {
        let identifier = String(describing: T.self).withoutTypeExtension
        return try self.instance(identifier: identifier)
    }
    
    func instance<T>(tag: String) throws -> T {
        let elementType = String(describing: T.self).withoutTypeExtension
        let identifier = elementType + tag
        return try self.instance(identifier: identifier)
    }
    
    func instance<GenericType, ImplementationType>(_ elementType: ImplementationType) throws -> GenericType {
        let elementTypeIdentifier = String(describing: ImplementationType.self).withoutTypeExtension
        let typeSpecificIdentifier = String(describing: GenericType.self).withoutTypeExtension
        let identifier = elementTypeIdentifier + typeSpecificIdentifier
        return try self.instance(identifier: identifier)
    }
    
    private func instance<T>(identifier: String) throws -> T {
        guard let factory = self.factories.value[identifier],
            let element = try factory.resolve(pool: self) as? T else {
                throw ContainerError.unregisteredValue(T.self)
        }
        return element
    }
}
