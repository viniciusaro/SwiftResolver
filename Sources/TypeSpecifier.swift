final public class TypeSpecifier {
    private let onRegister: (String) -> Void
    
    init(onRegister: @escaping (String) -> Void) {
        self.onRegister = onRegister
    }
    
    public func `as`<T>(_ type: T) {
        self.onRegister(String(describing: T.self))
    }
}
