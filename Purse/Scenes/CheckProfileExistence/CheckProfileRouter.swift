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
        pushView(with: .login)
    }
    
    func presentCreateProfileView() {
        pushView(with: .createAccount)
    }
    
    private func pushView(with actionType: LoginPresenter.ActionType) {
        guard
            let view = view,
            let targetView: LoginViewController = view.storyboard?.instantiateViewController() else {
            return
        }

        targetView.configurator = LoginConfigurator(actionType: actionType)

        view.navigationController?.pushViewController(targetView, animated: true)
    }
}
