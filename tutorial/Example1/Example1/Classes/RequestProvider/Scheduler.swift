import Foundation

protocol Scheduler {
    func run(_ block: @escaping () -> Void) -> Void
}

final class MainScheduler: Scheduler {
    static let instance = MainScheduler()
    func run(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}
