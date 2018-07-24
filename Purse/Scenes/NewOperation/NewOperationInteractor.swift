import Foundation

class NewOperationInteractor: Queryable {
    unowned var presenter: NewOperationPresenter
    
    init(presenter: NewOperationPresenter) {
        self.presenter = presenter
    }
}

// MARK: - NewOperationInteractorProtocol

extension NewOperationInteractor: NewOperationInteractorProtocol {
    func createIncome(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ()) {
        let url = "operation/income"
        post(url: url, headers: headers, credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func createOutgo(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ()) {
        let url = "operation/outgo"
        post(url: url, headers: headers, credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func createTransfer(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ()) {
        let url = "operation/transfer"
        post(url: url, headers: headers, credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
}
