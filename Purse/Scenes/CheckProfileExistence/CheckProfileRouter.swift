import UIKit

class CheckProfileRouter {
    weak var view: CheckProfileViewController?
    
    init(view: CheckProfileViewController?) {
        self.view = view
    }
}

// MARK: - CheckProfileRouterProtocol

extension CheckProfileRouter: CheckProfileRouterProtocol {
    func presentLoginView() {
        pushView(actionType: .login)
    }
    
    func presentCreateProfileView() {
        pushView(actionType: .createAccount)
    }
    
    private func pushView(actionType: LoginPresenter.ActionType) {
        guard let view = view else {
            return
        }

        let configurator = LoginConfigurator(actionType: actionType)
        view.navigationController?.pushViewController(configurator.viewController, animated: true)
    }
}
