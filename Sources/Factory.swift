final class Factory<T>: FactoryType {
    typealias Builder = () throws -> T
    private let scope: Scope
    private let builder: Builder
    private(set) var instanceCount = 0
    
    init(scope: Scope, builder: @escaping Builder) {
        self.scope = scope
        self.builder = builder
    }
    
    func resolve(pool: DependencyPool) throws -> T {
        switch self.scope {
        case .instance: return try self.build()
        case .singleton: return try self.singletonOrBuild(pool: pool)
        case .shared: return try self.sharedOrBuild(pool: pool)
        }
    }
    
    private func sharedOrBuild(pool: DependencyPool) throws -> T {
        if let instance: T = pool.sharedInstance() {
            return instance
        }
        return try self.buildAndRegisterInScope(pool: pool)
    }
    
    private func singletonOrBuild(pool: DependencyPool) throws -> T {
        if let instance: T = pool.singletonInstance() {
            return instance
        }
        return try self.buildAndRegisterInScope(pool: pool)
    }
    
    private func buildAndRegisterInScope(pool: DependencyPool) throws -> T {
        let instance = try self.build()
        switch self.scope {
        case .instance: break
        case .singleton: pool.registerSingleton(instance: instance)
        case .shared: pool.registerShared(instance: instance)
        }
        return instance
    }
    
    private func build() throws -> T {
        self.instanceCount += 1
        return try self.builder()
    }
}
