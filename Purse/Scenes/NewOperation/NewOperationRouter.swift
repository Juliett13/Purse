class NewOperationRouter {
    weak var view: NewOperationViewController?
    
    init(view: NewOperationViewController?) {
        self.view = view
    }
}

// MARK: - NewOperationRouterProtocol

extension NewOperationRouter: NewOperationRouterProtocol
{
    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
}


