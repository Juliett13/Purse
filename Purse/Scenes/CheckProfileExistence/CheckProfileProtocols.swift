// MARK: - View

protocol CheckProfileViewProtocol: class {}

// MARK: - Presenter

protocol CheckProfilePresenterProtocol {
    func pushLoginVC()
    func pushCreateProfileVC()
}

// MARK: - Router

protocol CheckProfileRouterProtocol {
    func presentLoginView()
    func presentCreateProfileView()
}
