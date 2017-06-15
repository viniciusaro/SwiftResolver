final class DependencyPool {
    private var factories: [String: AnyFactory] = [:]
    private var sharedInstances = InstancePool()
    private var singletonInstances = InstancePool()
    
    func instance<T>() throws -> T {
        let identifier = String(describing: T.self)
        guard let factory = self.factories[identifier],
            let element = try factory.resolve(pool: self) as? T else {
            throw ContainerError.unregisteredValue(T.self)
        }
        return element
    }
    
    func register<Factory: FactoryType>(_ factory: Factory) {
        let identifier = String(describing: Factory.Element.self)
        self.factories[identifier] = factory.asAny()
    }
    
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
        guard let factory = self.factories[identifier] else {
            return 0
        }
        return factory.instanceCount
    }
}
