import UIKit

protocol CheckProfileRouterProtocol {
    func presentLoginView()
    func presentCreateProfileView()
}

class CheckProfileRouter: CheckProfileRouterProtocol {
    weak var view: CheckProfileViewController?
    
    init(view: CheckProfileViewController?) {
        self.view = view
    }
    
    func presentLoginView() {
        pushView(with: .login)
    }
    
    func presentCreateProfileView() {
        pushView(with: .createAccount)
    }
    
    private func pushView(with actionType: LoginPresenter.ActionType) {
        guard let view = view else {
            return
        }
        
        guard let targetVC = view.storyboard?.instantiateViewController(withIdentifier: LoginViewController.reuseId) as? LoginViewController else {
            return
        }
        
        let router = LoginRouter(view: targetVC)
        let presenter = LoginPresenter(view: targetVC, router: router,  actionType: actionType)
        targetVC.presenter = presenter
        view.navigationController?.pushViewController(targetVC, animated: true)
    }
}
