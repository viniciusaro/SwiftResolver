final class GithubRepository {
    private let requestProvider: RequestProvider
    
    init(requestProvider: RequestProvider) {
        self.requestProvider = requestProvider
    }
    
    func repositories() -> Future<[GithubRepositoryInformation]> {
        return self.requestProvider.get(GithubTarget.all)
    }
}
