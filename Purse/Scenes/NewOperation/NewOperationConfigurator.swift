protocol NewOperationConfiguratorProtocol {
    func configure(view: NewOperationViewController)
}

// MARK: - NewOperationConfiguratorProtocol

class NewOperationConfigurator: NewOperationConfiguratorProtocol {

    let operationType: Operation.Types
    let accounts: [Account]

    init(operationType: Operation.Types, accounts: [Account]) {
        self.operationType = operationType
        self.accounts = accounts
    }

    func configure(view: NewOperationViewController) {
        let router = NewOperationRouter(view: view)
        let presenter = NewOperationPresenter(view: view, router: router, operationType: operationType.rawValue, accounts: accounts)
        let interactor = NewOperationInteractor(presenter: presenter)
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
