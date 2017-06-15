protocol FactoryType {
    associatedtype Element
    func resolve(pool: DependencyPool) throws -> Element
    var instanceCount: Int { get }
}

extension FactoryType {
    func asAny() -> AnyFactory {
        return AnyFactory(factory: self)
    }
}

final class AnyFactory: FactoryType {
    private let resolver: (DependencyPool) throws -> Any
    private let instanceCountClosure: () -> Int
    
    var instanceCount: Int {
        return self.instanceCountClosure()
    }
    
    init<Factory: FactoryType>(factory: Factory) {
        self.resolver = factory.resolve
        self.instanceCountClosure = { factory.instanceCount }
    }
    
    func resolve(pool: DependencyPool) throws -> Any {
        return try self.resolver(pool)
    }
}
