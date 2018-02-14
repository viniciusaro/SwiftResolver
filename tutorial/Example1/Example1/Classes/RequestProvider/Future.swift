import Foundation

final class Future<T> {
    typealias Callback = (Result<T>) -> Void
    private var onNext: Callback?
    
    init(configuration: (@escaping Callback) -> Void) {
        configuration { value in
            self.onNext?(value)
        }
    }
    
    func onNext(_ callback: @escaping Callback) {
        self.onNext = callback
    }
}

extension Future {
    static func error(_ error: Swift.Error) -> Future<T> {
        return Future { observer in
            observer(.error(error))
        }
    }
}

extension Future {
    func observeOn(_ scheduler: Scheduler) -> Future<T> {
        return Future { observer in
            self.onNext { result in
                scheduler.run {
                    observer(result)
                }
            }
        }
    }
}

extension Future {
    func map<B>(transform: @escaping (T) throws -> B) -> Future<B> {
        return Future<B> { observer in
            self.onNext { result in
                switch result {
                case .success(let value):
                    do {
                        observer(.success(try transform(value)))
                    } catch {
                        observer(.error(error))
                    }
                case .error(let error):
                    observer(.error(error))
                }
            }
        }
    }
}
