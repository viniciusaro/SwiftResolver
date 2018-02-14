import SwiftResolver

struct AppDependencies {
    // list any depedencies needed to register classes
}

final class AppContainer {
    private let container = Container()
    
    init(dependencies: AppDependencies) {
        self.registerWith(dependencies: dependencies)
    }
    
    func resolve<T>() -> T {
        return self.container.resolve()
    }
    
    private func registerWith(dependencies: AppDependencies) {
        self.container.register { RequestProvider() }
        
        self.container.register { GithubRepository(requestProvider: $0) }
        
        self.container.register { AuthenticationRepository(requestProvider: $0) }
        
        self.container.register { GithubViewController(githubRepository: $0, authRepository: $1) }
    }
}
