import UIKit

// MARK: - LoginConfiguratorProtocol

class LoginConfigurator: LoginConfiguratorProtocol {

    var viewController: UIViewController

    required init(actionType: LoginPresenter.ActionType) {
        let loginView: LoginViewController? = UIStoryboard(storyboard: .main).instantiateViewController()
        guard let view = loginView else {
            viewController = UIViewController()
            return
        }
        
        let router = LoginRouter(view: view)
        let presenter = LoginPresenter(view: view, router: router, actionType: actionType)
        view.presenter = presenter
        let interactor = LoginInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
