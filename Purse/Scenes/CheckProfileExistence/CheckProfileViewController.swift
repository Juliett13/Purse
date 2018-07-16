import UIKit

protocol CheckProfileViewProtocol: class {
    func instantiateViewController(with reuseId: String) -> UIViewController? //
    func push(_ viewController: UIViewController) //
}

class CheckProfileViewController: UIViewController, CheckProfileViewProtocol {
    
    var presenter: CheckProfilePresenterProtocol!
    
    @IBAction func profileExists(_ sender: Any) {
        presenter.pushLoginVC()
    }
    
    @IBAction func profileDoesNotExist(_ sender: Any) {
        presenter.pushCreateProfileVC()
    }
    
    override func viewDidLoad() {
        presenter = CheckProfilePresenter(view: self)
    }
    
    func instantiateViewController(with reuseId: String) -> UIViewController? {
        return storyboard?.instantiateViewController(withIdentifier: reuseId)
    }

    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
