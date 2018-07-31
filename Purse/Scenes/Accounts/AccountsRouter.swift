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
    func pushNewAccountView() {
        guard let view = view else {
            return
        }

        let configurator = NewAccountConfigurator()

        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }

    func pushNewOperationView(with operationType: OperationModel.Types, accounts: [AccountModel]) {
        guard let view = view else {
            return
        }

        let configurator = NewOperationConfigurator(operationType: operationType, accounts: accounts)
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }

    func popToRootView() {
        view?.navigationController?.popToRootViewController(animated: true)
    }
}
