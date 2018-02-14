import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let container = AppContainer(dependencies: AppDependencies())
        let viewController = container.resolve() as GithubViewController
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return true
    }
}
