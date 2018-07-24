import Foundation

class LoginPresenter {
    unowned let view: LoginViewProtocol
    var interactor: LoginInteractorProtocol!
    let router: LoginRouterProtocol

    private let loginFieldsCount = 2

    var actionType: ActionType
    var login = ""
    var password = ""

    enum FieldType: Int {
        case login = 0
        case password = 1
    }

    enum ActionType {
        case createAccount
        case login
    }


    init(view: LoginViewController, router: LoginRouterProtocol, actionType: ActionType) {
        self.view = view
        self.router = router
        self.actionType = actionType
    }
}

// MARK: - LoginPresenterProtocol

extension LoginPresenter: LoginPresenterProtocol {
    
    var fieldsCount: Int {
        get {
            return loginFieldsCount
        }
    }
    
    func fieldName(for row: Int) -> String {
        switch row {
        case FieldType.login.rawValue:
            return("Логин")
        case FieldType.password.rawValue:
            return("Пароль")
        default:
            return ""
        }
    }

    func fieldIsSecure(for row: Int) -> Bool {
        return row == FieldType.password.rawValue
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
    
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, for row: Int) -> Bool {
        switch row {
        case FieldType.login.rawValue:
            guard let textRange = Range(range, in: login) else
            {
                return false
            }
            login = login.replacingCharacters(in: textRange, with: string)
            
        case FieldType.password.rawValue:
            guard let textRange = Range(range, in: password) else
            {
                return false
            }
            password = password.replacingCharacters(in: textRange, with: string)
            
        default:
            return false
        }
        
        return true
    }
    
    func tryLogin() {

        if login.isEmpty || password.isEmpty {
            view.showAlert(with: "Заполните все поля!", handler: nil)
            return
        }
        
        let credentials = [
            "name": login,
            "password": password
        ]

        switch actionType {
        case .createAccount:
            let onSuccess = { (data: NSDictionary) in
                let handler = { [weak self] in
                    self?.router.presentAccountsView()
                }
                self.view.showAlert(with: "Профиль создан!", handler: handler)
            }
            
            let onFailure = {
                self.view.showAlert(with: "Произошла ошибка при создании профиля!", handler: nil)
            }
            interactor.createUser(credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
            
        case .login:
            let onSuccess = { (data: NSDictionary) in
                self.router.presentAccountsView()
            }
            
            let onFailure = {
                self.view.showAlert(with: "Логин и пароль введены некорректно!", handler: nil)
            }
            interactor.loginUser(credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
        }
    }
}
