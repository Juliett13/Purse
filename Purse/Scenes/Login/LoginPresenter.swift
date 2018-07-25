import Foundation

class LoginPresenter {
    unowned let view: LoginViewProtocol
    var interactor: LoginInteractorProtocol!
    let router: LoginRouterProtocol

    private let loginFieldsCount = 2

    var actionType: ActionType
    var login = ""
    var password = ""

    // REVIEW: Practice shows that using enum with values to manage cells order is tiresome and dangerous if screen structure changes.
    // Consider putting enum cases into array.
    // enum Sections
    enum FieldType: Int {
        case login = 0
        case password = 1
    }
    
    // This way you will have only to switch items order in the array. For example [.password, .login].
    let sections: [FieldType] = [.login, .password]

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
        // REVIEW: No need to explicidly use get without setter.
        return loginFieldsCount
    }
    
    func fieldName(for row: Int) -> String {
        
        // REVIEW: Example of array usage.
        guard let cell = self.sections.item(at: row) else
        {
            return String()
        }
        
        switch cell
        {
        case .login:
            return("Логин")
        case .password:
            return("Пароль")
        }
    }

    func fieldIsSecure(for row: Int) -> Bool {
        guard let cell = self.sections.item(at: row) else
        {
            return false
        }
        return cell == .password
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
        
        // Use DTO
        let credentials = [
            "name": login,
            "password": password
        ]

        switch actionType {
        case .createAccount:
            let onSuccess: (NSDictionary) -> Void = { [weak self] data in
                let handler = { [weak self] in
                    self?.router.presentAccountsView()
                }
                self?.view.showAlert(with: "Профиль создан!", handler: handler)
            }
            
            // REVIEW: Don't use strong self in blocks. Fix in other places too.
            let onFailure: () -> Void = { [weak self] in
                self?.view.showAlert(with: "Произошла ошибка при создании профиля!", handler: nil)
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
