public enum Scope {
    case instance
    case shared
    case singleton
    case eagerSingleton
}

final public class Container {
    public typealias RegistrantBlock = (Registrant) -> Void
    
    private let pool = DependencyPool()
    private lazy var registrant = Registrant(pool: self.pool)
    
    public init(registrant: RegistrantBlock) {
        registrant(self.registrant)
    }
    
    public func resolve<T>() -> T {
        return self.resolve { try self.pool.instance() }
    }
    
    public func resolve<T, Specifier>(_ specificType: Specifier) -> T {
        return self.resolve { try self.pool.instance(specificType) }
    }
    
    public func resolve<T>(_ tag: String) -> T {
        return self.resolve { try self.pool.instance(tag: tag) }
    }
    
    public func resolve<T, StringRepresentable: RawRepresentable>(_ tag: StringRepresentable) -> T where StringRepresentable.RawValue == String {
        return self.resolve { try self.pool.instance(tag: tag.rawValue) }
    }
    
    private func resolve<T>(_ resolverMethod: () throws -> T) -> T {
        do {
            self.pool.clearShared()
            let instance = try resolverMethod() as T
            return instance
        } catch let error as ContainerError<T> {
            fatalError(error.localizedDescription)
        } catch {
            fatalError("Unregistered type \(T.self)")
        }
    }
    
    public func instanceCountFor<T>(_ type: T.Type) -> Int {
        return self.pool.instanceCountFor(type: T.self)
    }
}

final public class Registrant {
    public typealias Builder0<T> = () -> T
    public typealias Builder1<T, A> = ((A)) -> T
    public typealias Builder2<T, A, B> = ((A, B)) -> T
    public typealias Builder3<T, A, B, C> = ((A, B, C)) -> T
    public typealias Builder4<T, A, B, C, D> = ((A, B, C, D)) -> T
    public typealias Builder5<T, A, B, C, D, E> = ((A, B, C, D, E)) -> T
    
    private unowned let pool: DependencyPool
    
    fileprivate init(pool: DependencyPool) {
        self.pool = pool
    }
    
    @discardableResult
    public func register<T>(scope: Scope = .instance, _ builder: @escaping Builder0<T>) -> TypeSpecifier {
        let factory = Factory<T>(scope: scope, builder: builder)
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A>(scope: Scope = .instance, _ builder: @escaping Builder1<T, A>) -> TypeSpecifier {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B>(scope: Scope = .instance, _ builder: @escaping Builder2<T, A, B>) -> TypeSpecifier {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B, C>(scope: Scope = .instance, _ builder: @escaping Builder3<T, A, B, C>) -> TypeSpecifier {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B, C, D>(scope: Scope = .instance, _ builder: @escaping Builder4<T, A, B, C, D>) -> TypeSpecifier {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B, C, D, E>(scope: Scope = .instance, _ builder: @escaping Builder5<T, A, B, C, D, E>) -> TypeSpecifier {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
    }
}
