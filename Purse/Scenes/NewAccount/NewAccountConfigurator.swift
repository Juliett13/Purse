import UIKit

// MARK: - NewAccountConfiguratorProtocol

class NewAccountConfigurator: NewAccountConfiguratorProtocol {

    var viewController: UIViewController

    init() {
        let newAccountView: NewAccountViewController? = UIStoryboard(storyboard: .main).instantiateViewController()
        guard let view = newAccountView else {
            viewController = UIViewController()
            return
        }
        
        let router = NewAccountRouter(view: view)
        let presenter = NewAccountPresenter(view: view, router: router)
        let interactor = NewAccountInteractor(presenter: presenter)
        view.presenter = presenter
        presenter.interactor = interactor
        viewController = view
    }
}
