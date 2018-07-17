protocol CheckProfilePresenterProtocol {
    func pushLoginVC()
    func pushCreateProfileVC()
}

class CheckProfilePresenter: CheckProfilePresenterProtocol {
    
    unowned let view: CheckProfileViewProtocol
    internal let router: CheckProfileRouterProtocol

    init(view: CheckProfileViewProtocol, router: CheckProfileRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func pushLoginVC() {
        router.presentLoginView()
    }
    
    func pushCreateProfileVC() {
        router.presentCreateProfileView()
    }
}
