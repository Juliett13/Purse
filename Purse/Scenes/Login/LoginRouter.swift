import UIKit

protocol LoginRouterProtocol {
}

class LoginRouter: LoginRouterProtocol {
    weak var view: LoginViewController?
    
    init(view: LoginViewController?) {
        self.view = view
    }
    
}
