import Foundation

class LoginPresenter {
    unowned let view: LoginViewProtocol
    var interactor: LoginInteractorProtocol!
    let router: LoginRouterProtocol

    var actionType: ActionType
    var login = ""
    var password = ""

    enum Sections: Int {
        case login = 0
        case password = 1
    }
    
    let sections: [Sections] = [.login, .password]

    enum ActionType {
        case createAccount
        case login
    }

    init(view: LoginViewController,
         router: LoginRouterProtocol,
         actionType: ActionType) {

        self.view = view
        self.router = router
        self.actionType = actionType
    }
}

// MARK: - LoginPresenterProtocol

extension LoginPresenter: LoginPresenterProtocol {
    
    var fieldsCount: Int {
        return sections.count
    }
    
    func fieldName(for row: Int) -> String {
        
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
    
    func shouldChangeCharacters(in range: NSRange,
                                replacementString string: String,
                                for row: Int) -> Bool {

        guard let cell = self.sections.item(at: row) else
        {
            return false
        }

        switch cell {
        case .login:
            guard let textRange = Range(range, in: login) else
            {
                return false
            }
            login = login.replacingCharacters(in: textRange, with: string)
            
        case .password:
            guard let textRange = Range(range, in: password) else
            {
                return false
            }
            password = password.replacingCharacters(in: textRange, with: string)
        }
        return true
    }
    
    func tryLogin() {

        if login.isEmpty || password.isEmpty {
            view.showAlert(
                with: "Заполните все поля!",
                handler: nil)
            return
        }

        let dto = LoginDto(login: login, password: password)

        switch actionType {
        case .createAccount:
            let onSuccess: () -> Void = { [weak self] in
                let handler = { [weak self] in
                    self?.router.presentAccountsView()
                }
                self?.view.showAlert(
                    with: "Профиль создан!",
                    handler: handler)
            }
            
            let onFailure: () -> Void = { [weak self] in
                self?.view.showAlert(
                    with: "Произошла ошибка при создании профиля!",
                    handler: nil)
            }

            interactor.createUser(
                dto: dto,
                onSuccess: onSuccess,
                onFailure: onFailure)
            
        case .login:
            let onSuccess: () -> Void = { [weak self] in
                self?.router.presentAccountsView()
            }
            
            let onFailure: () -> Void  = { [weak self] in
                self?.view.showAlert(
                    with: "Логин и пароль введены некорректно!",
                    handler: nil)
            }

            interactor.loginUser(
                dto: dto,
                onSuccess: onSuccess,
                onFailure: onFailure)
        }
    }
}
