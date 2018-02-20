final public class TypeSpecifier<T> {
    private let typeInterpreter = TypeInterpreter()
    private let register: (String) -> Void
    
    init(register: @escaping (String) -> Void) {
        self.register = register
        self.typeInterpreter.append(type: T.self)
        self.register(ids: self.typeInterpreter.identifiers)
    }
    
    @discardableResult
    public func tag(_ tag: String) -> TypeSpecifier<T> {
        self.typeInterpreter.append(tag: tag)
        self.register(ids: self.typeInterpreter.identifiers)
        return self
    }
    
    @discardableResult
    public func tag<StringRepresentable: RawRepresentable>(_ tag: StringRepresentable) -> TypeSpecifier<T>
        where StringRepresentable.RawValue == String {
        self.typeInterpreter.append(tag: tag.rawValue)
        self.register(ids: self.typeInterpreter.identifiers)
        return self
    }
    
    @discardableResult
    public func `as`<GenericType>(_ type: GenericType) -> TypeSpecifier<T> {
        self.typeInterpreter.append(genericType: GenericType.self)
        self.register(ids: self.typeInterpreter.identifiers)
        return self
    }
    
    private func register(ids collection: [String]) {
        collection.forEach(self.register)
    }
}

final class TypeInterpreter {
    var identifiers: [String] {
        return self.combinations2by2(self._identifiers, +)
    }
    
    private var _identifiers: [String] = []
    
    func append<T>(type: T.Type) {
        self._identifiers.append(String(describing: T.self).withoutTypeExtension)
    }
    
    func append(tag: String) {
        self._identifiers.append(tag)
    }
    
    func append<GenericType>(genericType: GenericType.Type) {
        self._identifiers.append(String(describing: GenericType.self).withoutTypeExtension)
    }
    
    func identifierFor<T>(type: T.Type) -> String {
        return String(describing: T.self).withoutTypeExtension
    }
    
    func identifierFor<T>(type: T.Type, andTag tag: String) -> String {
        let elementType = String(describing: T.self).withoutTypeExtension
        return elementType + tag
    }
    
    func identifierFor<GenericType, ImplementationType>(genericType: GenericType.Type,
                                                        andImplementationType implementationType: ImplementationType.Type) -> String {
        let elementTypeIdentifier = String(describing: ImplementationType.self).withoutTypeExtension
        let typeSpecificIdentifier = String(describing: GenericType.self).withoutTypeExtension
        return elementTypeIdentifier + typeSpecificIdentifier
    }
    
    private func combinations2by2<T>(_ collection: [T], _ combine: (T, T) -> T) -> [T] {
        var combinations: [T] = []
        for i in 0..<collection.count {
            let value = collection[i]
            combinations.append(value)
            for j in i+1..<collection.count {
                let other = collection[j]
                combinations.append(combine(value, other))
            }
        }
        return combinations
    }
}
