
import Foundation

// REVIEW: Better place all module's protols in one file or in separate files if protocols are big enough. Just suggestion, not a requirement.

// MARK: - View

protocol LoginViewProtocol: class {
    func setButtonTitle(text: String)
    func showAlert(with message: String)
    func getCell(by row: Int) -> LoginTableViewCellInfoDisplayProtocol
}

// MARK: - Presenter

protocol LoginPresenterProtocol {
    var fieldsCount: Int { get }
    func configure(cell: LoginTableViewCellInfoDisplayProtocol, forRow row: Int)
    func tryLogin()
    func configureButton()
}

// MARK: - Router

protocol LoginRouterProtocol {
    func presentAccountsView()
}
