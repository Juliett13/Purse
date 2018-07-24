import Foundation

// MARK: - View

protocol LoginViewProtocol: class {
    func setButtonTitle(text: String)
    func showAlert(with message: String, handler: (() -> ()?)?) 
}

// MARK: - Presenter

protocol LoginPresenterProtocol: class {
    var fieldsCount: Int { get }
    func fieldName(for row: Int) -> String
    func tryLogin()
    func configureButton()
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, for row: Int) -> Bool 
    func fieldIsSecure(for row: Int) -> Bool 
}

// MARK: - Router

protocol LoginRouterProtocol {
    func presentAccountsView()
}

// MARK: - Interactor

protocol LoginInteractorProtocol: class {
    func createUser(credentials: [String: Any], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping () -> ())
    func loginUser(credentials: [String: Any], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping () -> ())
}
