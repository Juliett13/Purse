import Foundation
import UIKit

// MARK: - View

protocol NewOperationViewProtocol: class {
    func setConfiguration(firstAccountLabelText: String,
                          secondAccountLabelText: String,
                          secondAccountIsHidden: Bool)
    func showAlert(with message: String, handler: (() -> ()?)?)
}

// MARK: - Presenter

protocol NewOperationPresenterProtocol {
    var operationType: OperationModel.Types { get set }
    var accountsCount: Int { get }
    var firstAccountTag: Int { get }
    var secondAccountTag: Int { get }
    var sumTag: Int { get }
    var commentTag: Int { get }
    var allowTransfer: Bool { get }

    func operationTypeChanged(id: Int)
    func prepareView()
    func savePressed()
    func accountName(for row: Int) -> String
    func didSelectAccount(tag: Int, row: Int)
    func shouldChangeCharacters(in range: NSRange,
                                replacementString string: String,
                                tag: Int) -> Bool
}

// MARK: - Interactor

protocol NewOperationInteractorProtocol: class {
    func createIncome(dto: IncomeOutgoDto,
                      onSuccess: @escaping () -> (),
                      onFailure: @escaping () -> ())
    func createOutgo(dto: IncomeOutgoDto,
                     onSuccess: @escaping () -> (),
                     onFailure: @escaping () -> ())
    func createTransfer(dto: TransferDto,
                        onSuccess: @escaping () -> (),
                        onFailure: @escaping () -> ())
}

// MARK: - Router

protocol NewOperationRouterProtocol {
    func popView()
}

// MARK: - Configurator

protocol NewOperationConfiguratorProtocol {
    var viewController: UIViewController { get }
    init(operationType: OperationModel.Types, accounts: [AccountModel])
}
