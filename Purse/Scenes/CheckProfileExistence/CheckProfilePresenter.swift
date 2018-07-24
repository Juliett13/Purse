class CheckProfilePresenter {
    
    unowned let view: CheckProfileViewProtocol
    let router: CheckProfileRouterProtocol

    init(view: CheckProfileViewProtocol, router: CheckProfileRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - CheckProfilePresenterProtocol

extension CheckProfilePresenter: CheckProfilePresenterProtocol {
    func pushLoginVC() {
        router.presentLoginView()
    }
    
    func pushCreateProfileVC() {
        router.presentCreateProfileView()
    }
}
