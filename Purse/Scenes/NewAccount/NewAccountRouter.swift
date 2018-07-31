class NewAccountRouter {
    weak var view: NewAccountViewController?

    init(view: NewAccountViewController?) {
        self.view = view
    }
}

// MARK: - NewOperationRouterProtocol

extension NewAccountRouter: NewAccountRouterProtocol
{
    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
}
