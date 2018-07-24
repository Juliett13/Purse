import UIKit

class AccountsRouter {
    weak var view: AccountsViewController?
    
    init(view: AccountsViewController?) {
        self.view = view
    }
}

// MARK: - AccountsRouterProtocol

extension AccountsRouter: AccountsRouterProtocol
{
    func pushNewOperationView(with operationType: Operation.Types, accounts: [Account]) {
        guard
            let view = view,
            let targetView: NewOperationViewController = view.storyboard?.instantiateViewController()  else {
                return
        }

        targetView.configurator = NewOperationConfigurator(operationType: operationType, accounts: accounts)

        view.navigationController?.pushViewController(targetView, animated: true)
    }
}
