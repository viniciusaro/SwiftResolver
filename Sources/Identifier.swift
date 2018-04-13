final class Identifier: Hashable, CustomDebugStringConvertible {
    private let type: Any.Type?
    private let genericType: Any.Type?
    private let tag: String?
    
    private var idCollection: [String] {
        let collection = [
            String(describing: self.type),
            String(describing: self.genericType),
            String(describing: self.tag)
        ]
        
        return collection
            .filter { $0 != "nil" }
            .map {
                $0.replacingOccurrences(of: "Optional", with: "")
                    .replacingOccurrences(of: ".Protocol", with: "")
                    .replacingOccurrences(of: ".Type", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")
            }
    }
    
    init(type: Any.Type? = nil, genericType: Any.Type? = nil, tag: String? = nil) {
        self.type = type
        self.genericType = genericType
        self.tag = tag
    }
    
    var hashValue: Int {
        return self.key.hashValue
    }
    
    var key: String {
        return self.idCollection.joined()
    }
    
    var debugDescription: String {
        return self.key
    }
    
    static func == (lhs: Identifier, rhs: Identifier) -> Bool {
        return lhs.type == rhs.type &&
            lhs.genericType == rhs.genericType &&
            lhs.tag == rhs.tag
    }
}
