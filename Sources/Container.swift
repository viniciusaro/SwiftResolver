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
    
    private var pool = DependencyPool()
    
    public init() {}
    
    public func register<T>(scope: Scope = .instance, _ builder: @escaping Builder0<T>) {
        let factory = Factory<T>(scope: scope, builder: builder)
        self.pool.register(factory)
    }
    
    public func register<T, A>(scope: Scope = .instance, _ builder: @escaping Builder1<T, A>) {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance()))
        }
        self.pool.register(factory)
    }
    
    public func register<T, A, B>(scope: Scope = .instance, _ builder: @escaping Builder2<T, A, B>) {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                               self.pool.instance()))
        }
        self.pool.register(factory)
    }
    
    public func register<T, A, B, C>(scope: Scope = .instance, _ builder: @escaping Builder3<T, A, B, C>) {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                               self.pool.instance(),
                               self.pool.instance()))
        }
        self.pool.register(factory)
    }
    
    public func register<T, A, B, C, D>(scope: Scope = .instance, _ builder: @escaping Builder4<T, A, B, C, D>) {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                               self.pool.instance(),
                               self.pool.instance(),
                               self.pool.instance()))
        }
        self.pool.register(factory)
    }
    
    public func register<T, A, B, C, D, E>(scope: Scope = .instance, _ builder: @escaping Builder5<T, A, B, C, D, E>) {
        let factory = Factory<T>(scope: scope) { [unowned self] in
            return try builder((self.pool.instance(),
                               self.pool.instance(),
                               self.pool.instance(),
                               self.pool.instance(),
                               self.pool.instance()))
        }
        self.pool.register(factory)
    }
    
    public func resolve<T>() -> T {
        do {
            let instance = try self.pool.instance() as T
            self.pool.clearShared()
            return instance
        } catch let error as ContainerError<T> {
            fatalError(error.localizedDescription)
        } catch {
            fatalError()
        }
    }
    
    public func instanceCountFor<T>(_ type: T.Type) -> Int {
        return self.pool.instanceCountFor(type: T.self)
    }
}
