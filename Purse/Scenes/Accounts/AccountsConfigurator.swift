import UIKit

// MARK: - AccountsConfiguratorProtocol

class AccountsConfigurator: AccountsConfiguratorProtocol {

    var viewController: UIViewController

    init() {
        let accountsView: AccountsViewController? = UIStoryboard(storyboard: .main).instantiateViewController()
        guard let view = accountsView else {
            viewController = UIViewController()
            return
        }
        
        let router = AccountsRouter(view: view)
        let presenter = AccountsPresenter(view: view, router: router)
        let interactor = AccountsInteractor(presenter: presenter)
        view.presenter = presenter
        presenter.interactor = interactor
        viewController = view
    }
}
