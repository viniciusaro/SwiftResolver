final class DependencyPool {
    private let typeInterpreter = TypeInterpreter()
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
    func register<Factory: FactoryType>(_ factory: Factory) -> TypeSpecifier<Factory.Element> {
        return TypeSpecifier(register: { identifier in
            self.internalRegister(factory, identifier: identifier)
        })
    }
    
    private func internalRegister<Factory: FactoryType>(_ factory: Factory, identifier: String = "") {
        self.factories.mutate { $0[identifier] = factory.asAny() }
    }
}

extension DependencyPool {
    func instance<T>() throws -> T {
        let identifier = self.typeInterpreter.identifierFor(type: T.self)
        return try self.instance(identifier: identifier)
    }
    
    func instance<T>(tag: String) throws -> T {
        let identifier = self.typeInterpreter.identifierFor(type: T.self, andTag: tag)
        return try self.instance(identifier: identifier)
    }
    
    func instance<GenericType, ImplementationType>(_ elementType: ImplementationType) throws -> GenericType {
        let identifier = self.typeInterpreter.identifierFor(genericType: GenericType.self,
                                                            andImplementationType: ImplementationType.self)
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
