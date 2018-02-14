import Foundation

protocol TargetType {
    var url: String { get }
}

final class RequestProvider {
    func get<Model: Decodable>(_ target: TargetType) -> Future<Model> {
        return self.request(target).map { data in
            try JSONDecoder().decode(Model.self, from: data)
        }
    }
    
    private func request(_ target: TargetType) -> Future<Data> {
        guard let url = URL(string: target.url) else {
            return Future.error(DataError.invalidTarget(target))
        }
        
        return Future { observer in
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    observer(.success(data))
                } else if let error = error {
                    observer(.error(error))
                }
            }.resume()
        }
    }
}
