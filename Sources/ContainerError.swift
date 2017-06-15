enum ContainerError<T>: Swift.Error {
    case unregisteredValue(T.Type)
    
    var localizedDescription: String {
        switch self {
        case let .unregisteredValue(type): return "Unregistered type \(type)"
        }
    }
}
