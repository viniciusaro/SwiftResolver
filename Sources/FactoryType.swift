protocol FactoryType {
    associatedtype Element
    var scope: Scope { get }
    var instanceCount: Int { get }
    func build() throws -> Element
}

extension FactoryType {
    func asAny() -> AnyFactory {
        return AnyFactory(factory: self)
    }
}

final class AnyFactory: FactoryType {
    let scope: Scope
    private let buildClosure: () throws -> Any
    private let instanceCountClosure: () -> Int

    var instanceCount: Int {
        return self.instanceCountClosure()
    }
    
    init<Factory: FactoryType>(factory: Factory) {
        self.buildClosure = factory.build
        self.instanceCountClosure = { factory.instanceCount }
        self.scope = factory.scope
    }
    
    func build() throws -> Any {
        return try self.buildClosure()
    }
}
