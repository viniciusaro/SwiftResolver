import Foundation

final class Atomic<T> {
    private var _value: T
    private let queue = DispatchQueue(label: "SwiftResolver.Atomic.Serial.Queue")
    
    var value: T {
        return self.queue.sync { self._value }
    }
    
    func mutate(_ transform: (inout T) -> Void) {
        _ = self.queue.sync { transform(&self._value) }
    }
    
    init(_ value: T) {
        self._value = value
    }
}
