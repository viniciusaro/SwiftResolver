final public class TypeSpecifier<T> {
    private let register: (Identifier) -> Void
    private let asTypeSpecifier: AsTypeSpecifier<T>
    private var tag: String? = nil
    
    init(register: @escaping (Identifier) -> Void) {
        self.register = register
        self.asTypeSpecifier = AsTypeSpecifier(register: register)
        register(.init(type: T.self))
    }
    
    @discardableResult
    public func tag(_ tag: String) -> AsTypeSpecifier<T> {
        self.tag = tag
        self.asTypeSpecifier.tag = tag
        self.register(.init(tag: tag))
        self.register(.init(type: T.self, tag: tag))
        return self.asTypeSpecifier
    }
    
    @discardableResult
    public func `as`<GenericType>(_ type: GenericType) -> AsTypeSpecifier<T> {
        return self.asTypeSpecifier.as(GenericType.self)
    }
}

final public class AsTypeSpecifier<T> {
    private let register: (Identifier) -> Void
    fileprivate(set) var tag: String?
    
    init(register: @escaping (Identifier) -> Void) {
        self.register = register
    }
    
    @discardableResult
    public func `as`<GenericType>(_ type: GenericType) -> Self {
        self.register(.init(genericType: GenericType.self))
        self.register(.init(genericType: GenericType.self, tag: self.tag))
        self.register(.init(type: T.self, genericType: GenericType.self))
        self.register(.init(type: T.self, genericType: GenericType.self, tag: self.tag))
        return self
    }
}

extension TypeSpecifier {
    @discardableResult
    public func tag<StringRepresentable: RawRepresentable>(_ tag: StringRepresentable) -> AsTypeSpecifier<T>
        where StringRepresentable.RawValue == String {
            return self.tag(tag.rawValue)
    }
}
