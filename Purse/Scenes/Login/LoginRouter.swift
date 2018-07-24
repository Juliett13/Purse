import UIKit

class LoginRouter {
    weak var view: LoginViewController?
    
    init(view: LoginViewController?) {
        self.view = view
    }
}

// MARK: - LoginRouterProtocol

extension LoginRouter: LoginRouterProtocol {
    func presentAccountsView() {
        guard
            let view = view,
            let targetView: AccountsViewController = view.storyboard?.instantiateViewController() else {
            return
        }

        targetView.configurator = AccountsConfigurator()

        view.navigationController?.pushViewController(targetView, animated: true)
    }
}








protocol AccountsScreenModuleInput: class
{
    func transferData(someData: String)
}

protocol AccountsScreenViewOutput: class
{
    
}


// Good approach is to use screen namespases in Viper.
// This is not a requirement, since VIPER implementation is out of scope task, just want you to know how it can be done.
class AccountsScreen
{
    let viewController: UIViewController
    
    init(configure:((AccountsScreenModuleInput) -> Void)?)
    {
        let view = ViewController()
        let presenter = Presenter()
    
        view.output = presenter
        
        // configure router, interactor
        
        self.viewController = view
        configure?(presenter)
    }
    
    class ViewController: UIViewController
    {
        var output: AccountsScreenViewOutput!
        // output - presenter
    }
    
    class Presenter: AccountsScreenModuleInput, AccountsScreenViewOutput
    {
        // view
        // interactor
        // router
        
        func transferData(someData: String)
        {
            
        }
    }
    
    class Interactor
    {
        // output - presenter
    }
    
    class Router
    {
        // view
    }
}
