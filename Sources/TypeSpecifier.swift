final public class TypeSpecifier {
    private let onRegister: (String) -> Void
    
    init(onRegister: @escaping (String) -> Void) {
        self.onRegister = onRegister
    }
    
    public func `as`<T>(_ type: T) {
        self.onRegister(String(describing: T.self))
    }
    
    public func tag(_ tag: String) {
        self.onRegister(tag)
    }
    
    public func tag<StringRepresentable: RawRepresentable>(_ tag: StringRepresentable) where StringRepresentable.RawValue == String {
        self.onRegister(tag.rawValue)
    }
}
