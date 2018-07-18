import UIKit

protocol LoginRouterProtocol {
    func presentAccountsView()
}

class LoginRouter: LoginRouterProtocol {
    weak var view: LoginViewController?
    
    init(view: LoginViewController?) {
        self.view = view
    }
    
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
    }
}
