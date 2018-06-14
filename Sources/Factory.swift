final class Factory<T>: FactoryType {
    typealias Builder = () throws -> T

    let scope: Scope
    private let builder: Builder
    private(set) var instanceCount = 0
    
    init(scope: Scope, builder: @escaping Builder) {
        self.scope = scope
        self.builder = builder
    }
    
    func build() throws -> T {
        self.instanceCount += 1
        return try self.builder()
    }
}
