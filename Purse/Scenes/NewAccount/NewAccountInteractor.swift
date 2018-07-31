class NewAccountInteractor {
    unowned var presenter: NewAccountPresenter

    init(presenter: NewAccountPresenter) {
        self.presenter = presenter
    }
}

// MARK: - NewAccountInteractorProtocol

extension NewAccountInteractor: NewAccountInteractorProtocol {
    func createAccount(account: AccountDto,
                       onSuccess: @escaping () -> (),
                       onFailure: @escaping () -> ()) {

        let request = Request.Account.Post(
            sum: account.sum,
            description: account.description
        )
        request.send().done { _ in
            onSuccess()
            }.catch { _ in
                onFailure()
        }
    }
}
