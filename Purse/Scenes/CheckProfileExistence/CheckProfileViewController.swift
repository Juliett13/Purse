import UIKit

class CheckProfileViewController: UIViewController, CheckProfileViewProtocol {
    
    var presenter: CheckProfilePresenterProtocol!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        let router = CheckProfileRouter(view: self)
        presenter = CheckProfilePresenter(view: self, router: router)
    }
}

// MARK: - IBActions

extension CheckProfileViewController {
    @IBAction func profileExists(_ sender: Any) {
        presenter.pushLoginVC()
    }
    
    @IBAction func profileDoesNotExist(_ sender: Any) {
        presenter.pushCreateProfileVC()
    }
}
