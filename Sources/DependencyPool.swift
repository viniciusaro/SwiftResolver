final class DependencyPool {
    private var factories: Atomic<[Int: AnyFactory]> = Atomic([:])
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
        let identifier = Identifier(type: T.self)
        guard let factory = self.factories.value[identifier.hashValue] else {
            return 0
        }
        return factory.instanceCount
    }
}

extension DependencyPool {
    func register<Factory: FactoryType>(_ factory: Factory) -> TypeSpecifier<Factory.Element> {
        return TypeSpecifier(register: { identifier in
            self.internalRegister(factory, identifier: identifier)
        })
    }
    
    private func internalRegister<Factory: FactoryType>(_ factory: Factory, identifier: Identifier) {
        self.factories.mutate { $0[identifier.hashValue] = factory.asAny() }
    }
}

extension DependencyPool {
    func instance<T>() throws -> T {
        return try self.instance(identifier: .init(type: T.self))
    }
    
    func instance<T>(tag: String) throws -> T {
        do {
            return try self.instance(identifier: Identifier(type: T.self, tag: tag))
        } catch {
            return try self.instance(identifier: Identifier(genericType: T.self, tag: tag))
        }
    }
    
    func instance<GenericType, ImplementationType>(_ elementType: ImplementationType) throws -> GenericType {
        return try self.instance(identifier: .init(type: ImplementationType.self, genericType: GenericType.self))
    }
    
    private func instance<T>(identifier: Identifier) throws -> T {
        guard let factory = self.factories.value[identifier.hashValue],
            let element = try factory.resolve(pool: self) as? T else {
                throw ContainerError.unregisteredValue(T.self)
        }
        return element
    }
}
