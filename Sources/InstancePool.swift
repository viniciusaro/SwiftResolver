final class InstancePool {
    private var instances: Atomic<[String: Any]> = Atomic([:])
    
    init() {}
    
    func register<T>(instance: T) {
        let identifier = String(describing: T.self)
        self.instances.mutate { $0[identifier] = instance }
    }
    
    func get<T>() -> T? {
        let identifier = String(describing: T.self)
        return self.instances.value[identifier] as? T
    }
    
    func clear() {
        self.instances.mutate { $0.removeAll() }
    }
}
