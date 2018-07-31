import Foundation
import UIKit

// MARK: - View

protocol NewAccountViewProtocol: class {
    func showAlert(with message: String, handler: (() -> ()?)?) 
}

// MARK: - Presenter

protocol NewAccountPresenterProtocol {
    func shouldChangeCharacters(in range: NSRange,
                                replacementString string: String,
                                tag: Int) -> Bool
    func accountNameTag() -> Int
    func accountBalanceTag() -> Int
    func savePressed()
}

// MARK: - Router

protocol NewAccountRouterProtocol {
    func popView()
}

// MARK: - Interactor

protocol NewAccountInteractorProtocol {
    func createAccount(account: AccountDto,
                       onSuccess: @escaping () -> (),
                       onFailure: @escaping () -> ())
}

// MARK: - Configurator

protocol NewAccountConfiguratorProtocol {
    var viewController: UIViewController { get }
}
