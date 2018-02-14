final class AuthenticationRepository {
    private let requestProvider: RequestProvider
    
    init(requestProvider: RequestProvider) {
        self.requestProvider = requestProvider
    }
}
