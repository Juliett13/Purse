import Foundation
import UIKit

// MARK: - View

protocol AccountsViewProtocol: class {
    func setOperationTypesConfiguration(onIncomePressed: @escaping () -> ()?,
                                        onOutgoPressed: @escaping () -> ()?,
                                        onTransferPressed: @escaping () -> ()?,
                                        viewWasHidden: @escaping () -> ()?)
    func setAccountsConfiguration(_ dropDownOptions: [String])
    func setAccountsButtonTitle(_ title: String) 
    func updateOperations()
    func updateSum(value: String)
    func setHidesOperationsButton(_ hidesOperationsButton: Bool) 
    func allowNewOperation() 
    func showAlert(with message: String,
                   yesHandler: (() -> ())?,
                   cancelHandler: (() -> ())?)
}

// MARK: - Presenter

protocol AccountsPresenterProtocol: class {
    var operationsCount: Int { get }
    var allowNewOperation: Bool { get }

    func prepareView()
    func configureOperationTypesView()
    func getInfo(for row: Int) -> String
    func getSum(for row: Int) -> String
    func accountIdDidChanged(_ id: Int)
    func operationTypeDidChanged(_ id: Int)
    func logout()
    func operationsButtonPressed()
}

// MARK: - Router

protocol AccountsRouterProtocol {
    func pushNewOperationView(with operationType: OperationModel.Types,
                              accounts: [AccountModel])
    func pushNewAccountView()
    func popToRootView() 
}

// MARK: - Interactor

protocol AccountsInteractorProtocol: class {
    func getIncomes(accountId: Int?,
                    onSuccess: @escaping ([OperationModel]) -> (),
                    onFailure: @escaping () -> ())
    func getOutgoes(accountId: Int?,
                    onSuccess: @escaping ([OperationModel]) -> (),
                    onFailure: @escaping () -> ())
    func getTransfers(accountId: Int?,
                      onSuccess: @escaping ([OperationModel]) -> (),
                      onFailure: @escaping () -> ())
    func getAllAccounts(onSuccess: @escaping ([AccountModel]) -> (),
                        onFailure: @escaping () -> ())
    func getAllOperations(accountId: Int?,
                          onSuccess: @escaping ([OperationModel]) -> (),
                          onFailure: @escaping () -> ())
}

// MARK: - Configurator

protocol AccountsConfiguratorProtocol {
    var viewController: UIViewController { get }
}
