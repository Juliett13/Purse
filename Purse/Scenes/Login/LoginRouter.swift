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
        guard let view = view else {
            return
        }

        let configurator = AccountsConfigurator()
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
}
