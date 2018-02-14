struct GithubTarget: TargetType {
    let url: String
    
    static var all: GithubTarget {
        return GithubTarget(url: "https://api.github.com/repositories")
    }
}
