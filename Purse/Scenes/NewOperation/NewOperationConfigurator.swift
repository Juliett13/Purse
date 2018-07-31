import UIKit

// MARK: - NewOperationConfiguratorProtocol

class NewOperationConfigurator: NewOperationConfiguratorProtocol {

    var viewController: UIViewController

    required init(operationType: OperationModel.Types, accounts: [AccountModel]) {
        let newOperationView: NewOperationViewController? = UIStoryboard(storyboard: .main).instantiateViewController()
        guard let view = newOperationView else {
            viewController = UIViewController()
            return
        }

        let router = NewOperationRouter(view: view)
        let presenter = NewOperationPresenter(
            view: view,
            router: router,
            operationType: operationType.rawValue,
            accounts: accounts)
        let interactor = NewOperationInteractor(presenter: presenter)
        view.presenter = presenter
        presenter.interactor = interactor
        viewController = view
    }
}
