public enum Scope {
    case instance
    case singleton
    case shared
}

final public class Container {
    public typealias Builder0<T> = () -> T
    public typealias Builder1<T, A> = ((A)) -> T
    public typealias Builder2<T, A, B> = ((A, B)) -> T
    public typealias Builder3<T, A, B, C> = ((A, B, C)) -> T
    public typealias Builder4<T, A, B, C, D> = ((A, B, C, D)) -> T
    public typealias Builder5<T, A, B, C, D, E> = ((A, B, C, D, E)) -> T
    
    private let pool = DependencyPool()
    
    public init() {}
    
    @discardableResult
    public func register<T>(scope: Scope = .instance, _ builder: @escaping Builder0<T>) -> TypeSpecifier<T> {
        let factory = Factory<T>(scope: scope, builder: builder)
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A>(scope: Scope = .instance, _ builder: @escaping Builder1<T, A>) -> TypeSpecifier<T> {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B>(scope: Scope = .instance, _ builder: @escaping Builder2<T, A, B>) -> TypeSpecifier<T> {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B, C>(scope: Scope = .instance, _ builder: @escaping Builder3<T, A, B, C>) -> TypeSpecifier<T> {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B, C, D>(scope: Scope = .instance, _ builder: @escaping Builder4<T, A, B, C, D>) -> TypeSpecifier<T> {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
    }
    
    @discardableResult
    public func register<T, A, B, C, D, E>(scope: Scope = .instance, _ builder: @escaping Builder5<T, A, B, C, D, E>) -> TypeSpecifier<T> {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance(),
                                self.pool.instance()))
        }
        return self.pool.register(factory)
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
            let instance = try resolverMethod() as T
            self.pool.clearShared()
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
