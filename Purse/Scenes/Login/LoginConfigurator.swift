protocol LoginConfiguratorProtocol {
    func configure(view: LoginViewController) 
}

// MARK: - LoginConfiguratorProtocol

class LoginConfigurator: LoginConfiguratorProtocol {

    let actionType: LoginPresenter.ActionType

    init(actionType: LoginPresenter.ActionType) {
        self.actionType = actionType
    }

    func configure(view: LoginViewController) {
        let router = LoginRouter(view: view)
        let presenter = LoginPresenter(view: view, router: router, actionType: actionType)
        view.presenter = presenter
        let interactor = LoginInteractor(presenter: presenter)
        presenter.interactor = interactor
    }
}
