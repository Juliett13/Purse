import UIKit

class LoginRouter: LoginRouterProtocol {
    weak var view: LoginViewController?
    
    init(view: LoginViewController?) {
        self.view = view
    }
    
    // REVIEW: Adwise - Previous Screen should not know of and assembly components of the next one. Account screen module should assembly itself and provide this router with viewController. 
    func presentAccountsView() {
        guard let view = view else {
            return
        }
        
        guard let targetVC = view.storyboard?.instantiateViewController(withIdentifier: AccountsViewController.reuseId) as? AccountsViewController else {
            return
        }
        let router = AccountsRouter(view: targetVC)
        let presenter = AccountsPresenter(view: targetVC, router: router)
        targetVC.presenter = presenter
        view.navigationController?.pushViewController(targetVC, animated: true)
        
        // REVIEW: Navigation code is reduced to this:
//        let accountsScreen = AccountsScreen { module in
//            module.transferData(someData: "some sata to transfer to the next screen")
//        }
//        view.navigationController?.pushViewController(accountsScreen.viewController, animated: true)
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
