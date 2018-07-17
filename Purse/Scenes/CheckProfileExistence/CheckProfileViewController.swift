import UIKit

protocol CheckProfileViewProtocol: class {}

class CheckProfileViewController: UIViewController, CheckProfileViewProtocol {
    
    var presenter: CheckProfilePresenterProtocol!
    
    @IBAction func profileExists(_ sender: Any) {
        presenter.pushLoginVC()
    }
    
    @IBAction func profileDoesNotExist(_ sender: Any) {
        presenter.pushCreateProfileVC()
    }
    
    override func viewDidLoad() {
        let router = CheckProfileRouter(view: self)
        presenter = CheckProfilePresenter(view: self, router: router)
    }
}
