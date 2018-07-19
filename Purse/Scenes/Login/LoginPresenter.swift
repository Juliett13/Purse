import UIKit

// REVIEW: There should be no UIKit in presenter. Presenter should be designed to be reusable on several platforms. for example, it should be usable in MacOs version of the app.
// UIKit must be in View and Router only.
// Presenter musn't know that you are wotking with UITableViewCell. If a need arise to use UICollectionView, presenter mustn't be affected.

class LoginPresenter: LoginPresenterProtocol {
    enum ActionType {
        case createAccount
        case login
    }
    
    var actionType: ActionType
    
    unowned let view: LoginViewProtocol
    
    // REVIEW: No need to use internal, all properties are internal by default.
    internal let router: LoginRouterProtocol
    let fieldsCount = 2
    
    init(view: LoginViewController, router: LoginRouterProtocol, actionType: ActionType) {
        self.view = view
        self.router = router
        self.actionType = actionType
    }
    
    // REVIEW: Not required, but nice to user.
    // Mask password input.
    // Use placeholders in textFields.
    func configure(cell: LoginTableViewCellInfoDisplayProtocol, forRow row: Int) {
        switch row {
        case 0:
            cell.display(info: "Логин")
        default:
            cell.display(info: "Пароль")
        }
    }
    
    func configureButton() {
        let name: String
        switch actionType {
        case .createAccount:
            name = "Создать"
        case .login:
            name = "Войти"
        }
        view.setButtonTitle(text: name)
    }
    
    // REVIEW: Input must be stored in presenter, not obtained from cell, because when you reload tableView, all data in cell will be gone. Please, refactor it.
    // You should update text in presenter in real time as user inputs to preserve it.
    func tryLogin() {
        let loginCell = view.getCell(by: 0)
        let passwordCell = view.getCell(by: 1)

        let login = loginCell.getTextFieldInfo()
        let password = passwordCell.getTextFieldInfo()
        
        guard let log = login, let pass = password else {
            return
        }
        
        // Alternative:
        //if log.isEmpty || pass.isEmpty
        if log == "" || pass == "" {
            view.showAlert(with: "Заполните все поля!")
            return
        }
        
        switch actionType {
        case .createAccount: ()
            //
        case .login: ()
            // 
        }
        
        router.presentAccountsView() //
    }
}
