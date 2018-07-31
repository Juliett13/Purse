import Foundation
import Alamofire
import PromiseKit
import SwiftKeychainWrapper

class LoginInteractor
{
    unowned var presenter: LoginPresenterProtocol
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - LoginInteractorProtocol

extension LoginInteractor: LoginInteractorProtocol {
    func createUser(dto: LoginDto,
                    onSuccess: @escaping () -> (),
                    onFailure: @escaping () -> ()?) {

        let request = Request.User.Post(name: dto.login, password: dto.password)
        request.send().done { user in
            self.tokenObtained(user: user)
            onSuccess()
            }.catch { _ in
                onFailure()
        }
    }

    func loginUser(dto: LoginDto,
                   onSuccess: @escaping () -> (),
                   onFailure: @escaping () -> ()?) {
        
        let request = Request.User.Login.Post(name: dto.login, password: dto.password)
        request.send().done { user in
            self.tokenObtained(user: user)
            onSuccess()
            }.catch { _ in
                onFailure()
        }
    }

    private func tokenObtained(user: UserModel)
    {
        KeychainWrapper.standard.set(user.token, forKey: "userToken")
    }
}


