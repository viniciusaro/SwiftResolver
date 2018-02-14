import Foundation

enum Result<T> {
    case success(T)
    case error(Swift.Error)
}
