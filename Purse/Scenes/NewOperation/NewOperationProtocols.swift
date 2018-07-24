import Foundation

// MARK: - View

protocol NewOperationViewProtocol: class {
    func setConfiguration(firstAccountLabelText: String, secondAccountLabelText: String, secondAccountIsHidden: Bool)
    func showAlert(with message: String, handler: (() -> ()?)?) 
}

// MARK: - Presenter

protocol NewOperationPresenterProtocol {
    var operationType: Int { get set }
    var accountsCount: Int { get }
    var firstAccountTag: Int { get }
    var secondAccountTag: Int { get }
    var sumTag: Int { get }
    var commentTag: Int { get }
    func operationTypeChanged(id: Int)
    func prepareView()
    func accountName(for row: Int) -> String
    func didSelectAccount(tag: Int, row: Int)
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, tag: Int) -> Bool
    func save()
}

// MARK: - Interactor

protocol NewOperationInteractorProtocol: class {
    func createIncome(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
    func createOutgo(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
    func createTransfer(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
}

// MARK: - Router

protocol NewOperationRouterProtocol {
    func popView()
}

