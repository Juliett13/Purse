protocol AccountsConfiguratorProtocol {
    func configure(view: AccountsViewController)
}

// MARK: - AccountsConfiguratorProtocol

class AccountsConfigurator: AccountsConfiguratorProtocol {
    func configure(view: AccountsViewController) {
        let router = AccountsRouter(view: view)
        let presenter = AccountsPresenter(view: view, router: router)
        let interactor = AccountsInteractor(presenter: presenter)
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
