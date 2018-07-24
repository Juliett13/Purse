import Foundation

// REVIEW: Good job with protocols organization.

// MARK: - View

protocol AccountsViewProtocol: class {
    func setOperationTypesConfiguration(onIncomePressed: @escaping () -> ()?, onOutgoPressed: @escaping () -> ()?, onTransferPressed: @escaping () -> ()?)
    func setAccountsConfiguration(with title: String, dropDownOptions: [String])
    func updateOperations()
    func updateSum(value: String)
}

// MARK: - Presenter

protocol AccountsPresenterProtocol: class {
    var operationsCount: Int { get }
    func prepareView()
    func configureOperationTypesView()
    func getInfo(for row: Int) -> String
    func getSum(for row: Int) -> String
    func accountIdDidChanged(_ id: Int)
    func operationTypeDidChanged(_ id: Int)
}

// MARK: - Router

protocol AccountsRouterProtocol {
    func pushNewOperationView(with operationType: Operation.Types, accounts: [Account])
}

// MARK: - Interactor

protocol AccountsInteractorProtocol: class {
    func getOperations(operationType: String, account: String, onSuccess: @escaping ([Operation]) -> (), onFailure: @escaping () -> ())
    func getAllAccounts(onSuccess: @escaping ([Account]) -> (), onFailure: @escaping () -> ())
    func createAccount(credentials: [String : Any], onSuccess: @escaping (NSArray) -> (), onFailure: @escaping () -> ())
}
