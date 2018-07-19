import UIKit

protocol AccountsRouterProtocol {
    func pushNewOperationView(with operationType: Operation.operations) 
}

class AccountsRouter: AccountsRouterProtocol {
    weak var view: AccountsViewController?
    
    init(view: AccountsViewController?) {
        self.view = view
    }
    
    func pushNewOperationView(with operationType: Operation.operations) {
        // REVIEW: You can unite several guard cases into one if they share the same `else` action.

        guard
            let view = view,
            let targetVC = view.storyboard?.instantiateViewController(withIdentifier: NewOperationViewController.reuseId) as? NewOperationViewController  else {
            return
        }
        
        let presenter = NewOperationPresenter(view: targetVC, operationType: operationType.rawValue)
        targetVC.presenter = presenter
        view.navigationController?.pushViewController(targetVC, animated: true)
    }
}
