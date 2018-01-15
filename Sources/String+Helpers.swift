import Foundation

extension String {
    var withoutTypeExtension: String {
        let string = self.split(separator: ".").first ?? ""
        return String(string)
    }
}
