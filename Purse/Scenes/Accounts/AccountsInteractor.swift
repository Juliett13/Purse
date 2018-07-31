import Foundation
import PromiseKit

class AccountsInteractor {
    unowned var presenter: AccountsPresenterProtocol

    init(presenter: AccountsPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - AccountsInteractorProtocol

extension AccountsInteractor: AccountsInteractorProtocol  {
    func getAllOperations(accountId: Int?,
                          onSuccess: @escaping ([OperationModel]) -> (),
                          onFailure: @escaping () -> ()) {
        let request = Request.Operation.Get(accountId: accountId)
        perform(promise: request.send(), onSuccess: onSuccess, onFailure: onFailure)
    }

    func getIncomes(accountId: Int?,
                    onSuccess: @escaping ([OperationModel]) -> (),
                    onFailure: @escaping () -> ()) {
        let request = Request.Operation.Income.Get(accountId: accountId)
        perform(promise: request.send(), onSuccess: onSuccess, onFailure: onFailure)
    }

    func getOutgoes(accountId: Int?,
                    onSuccess: @escaping ([OperationModel]) -> (),
                    onFailure: @escaping () -> ()) {
        let request = Request.Operation.Outgo.Get(accountId: accountId)
        perform(promise: request.send(), onSuccess: onSuccess, onFailure: onFailure)
    }

    func getTransfers(accountId: Int?,
                      onSuccess: @escaping ([OperationModel]) -> (),
                      onFailure: @escaping () -> ()) {
        let request = Request.Operation.Transfer.Get(accountId: accountId)
        perform(promise: request.send(), onSuccess: onSuccess, onFailure: onFailure)
    }

    func getAllAccounts(onSuccess: @escaping ([AccountModel]) -> (),
                        onFailure: @escaping () -> ()) {
        let request = Request.Account.Get()
        perform(promise: request.send(), onSuccess: onSuccess, onFailure: onFailure)
    }

    private func perform<T>(promise: Promise<[T]>,
                            onSuccess: @escaping ([T]) -> (),
                            onFailure: @escaping () -> () ) {
        promise.done { array in
            onSuccess(array)
            }.catch { _ in
                onFailure()
        }
    }
}

