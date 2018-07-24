import Foundation

class LoginInteractor: Queryable
{
    unowned var presenter: LoginPresenterProtocol
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - LoginInteractorProtocol

extension LoginInteractor: LoginInteractorProtocol {
    func createUser(credentials: [String : Any], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping () -> ()) {
        let url = "user/"
        userQuery(url: url, credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func loginUser(credentials: [String : Any], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping () -> ()) {
        let url = "user/login/"
        userQuery(url: url, credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func userQuery(url: String, credentials: [String : Any], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping () -> ()) {
        let onSuccess: (Any) -> () = {any in
            if let dict = any as? NSDictionary
            {
                self.TokenObtained(data: dict)
                onSuccess(dict)
            }
        }
        
        post(url: url, headers: [:], credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    private func TokenObtained(data: NSDictionary)
    {
        token = data.value(forKey: "token") as? String
        username = data.value(forKey: "username") as? String

        print(token)

        // !! save in keychain
        
    }
}
