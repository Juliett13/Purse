import UIKit

protocol LoginPresenterProtocol {
    var fieldsCount: Int { get }
    func configure(cell: LoginTableViewCellInfoDisplayProtocol,forRow row: Int)
    func tryLogin()
    func configureButton() 
}

class LoginPresenter: LoginPresenterProtocol {
    enum ActionType {
        case createAccount
        case login
    }
    
    var actionType: ActionType
    
    unowned let view: LoginViewProtocol
    internal let router: LoginRouterProtocol
    let fieldsCount = 2
    
    init(view: LoginViewController, router: LoginRouterProtocol, actionType: ActionType) {
        self.view = view
        self.router = router
        self.actionType = actionType
    }
    
    func configure(cell: LoginTableViewCellInfoDisplayProtocol,forRow row: Int) {
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
    
    func tryLogin() {
        let loginCell = view.getCell(by: 0)
        let passwordCell = view.getCell(by: 1)

        let login = loginCell.getTextFieldInfo()
        let password = passwordCell.getTextFieldInfo()
        
        guard let log = login, let pass = password else {
            return
        }
        
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
