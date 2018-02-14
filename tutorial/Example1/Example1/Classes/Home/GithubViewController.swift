import UIKit

final class GithubViewController: UIViewController {
    private let githubRepository: GithubRepository
    private let authRepository: AuthenticationRepository
    
    init(githubRepository: GithubRepository, authRepository: AuthenticationRepository) {
        self.githubRepository = githubRepository
        self.authRepository = authRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.loadData()
    }
    
    private func loadData() {
        self.githubRepository.repositories()
            .observeOn(MainScheduler.instance)
            .onNext { result in
                switch result {
                case .success(let repositories):
                    print("repos: \(repositories)")
                case .error(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
