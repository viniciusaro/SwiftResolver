final class InstancePool {
    private var instances: [String: Any] = [:]
    
    init() {}
    
    func register<T>(instance: T) {
        let identifier = String(describing: T.self)
        self.instances[identifier] = instance
    }
    
    func get<T>() -> T? {
        let identifier = String(describing: T.self)
        return self.instances[identifier] as? T
    }
    
    func clear() {
        self.instances.removeAll()
    }
}
