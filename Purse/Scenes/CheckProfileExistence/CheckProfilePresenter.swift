protocol CheckProfilePresenterProtocol {
    func pushLoginVC()
    func pushCreateProfileVC()
}

class CheckProfilePresenter: CheckProfilePresenterProtocol {
    
    unowned let view: CheckProfileViewProtocol
    
    init(view: CheckProfileViewProtocol) {
        self.view = view
    }
    
    func pushLoginVC() {
        pushVC(with: LoginPresenter.ActionType.login)
    }
    
    func pushCreateProfileVC() {
        pushVC(with: LoginPresenter.ActionType.createAccount)
    }
    
    private func pushVC(with actionType: LoginPresenter.ActionType) {
        let targetVC = self.view.instantiateViewController(with: LoginViewController.reuseId) as! LoginViewController
        let presenter = LoginPresenter(view: targetVC,  actionType: actionType)
        targetVC.presenter = presenter
        self.view.push(targetVC)
    }
}
