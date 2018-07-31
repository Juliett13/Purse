import SwiftKeychainWrapper

class AccountsPresenter {
    unowned let view: AccountsViewProtocol
    var interactor: AccountsInteractorProtocol!
    let router: AccountsRouterProtocol
    
    private var operations = [OperationModel]()
    private var accounts = [AccountModel]()
    private var selectedAccountId = 0
    private var selectedOperationType = -1
    private var dropDownOptions = [String]()
    required init(view: AccountsViewController,
                  router: AccountsRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - AccountsPresenterProtocol

extension AccountsPresenter: AccountsPresenterProtocol {
    var operationsCount: Int {
            return operations.count
    }

    var allowNewOperation: Bool {
        return accounts.count > 0
    }

    func prepareView() {
        configureAccounts()
        presentOperations()
        view.setAccountsButtonTitle("Все счета")
    }
    
    func configureOperationTypesView() {
        let onIncomePressed = { [weak self] in
            self?.router.pushNewOperationView(
                with: .income,
                accounts: self?.accounts ?? [])
        }

        let onOutgoPressed = { [weak self] in
            self?.router.pushNewOperationView(
                with: .outgo,
                accounts: self?.accounts ?? [])
        }
        
        let onTransferPressed = { [weak self] in

            guard let count = self?.accounts.count, count > 1 else {
                self?.view.showAlert(
                    with: "Недостаточно счетов для осуществления перевода. Перейти к доступным операциям?",
                    yesHandler: { [weak self] in
                        self?.router.pushNewOperationView(
                            with: .income,
                            accounts: self?.accounts ?? [])
                },
                    cancelHandler: {})
                return
            }

            self?.router.pushNewOperationView(
                with: .transfer,
                accounts: self?.accounts ?? [])
        }

        let viewWasHidden = { [weak self] in
            self?.view.setHidesOperationsButton(false)
        }

        view.setOperationTypesConfiguration(
            onIncomePressed: onIncomePressed,
            onOutgoPressed: onOutgoPressed,
            onTransferPressed: onTransferPressed,
            viewWasHidden: viewWasHidden)
    }
    
    func getInfo(for row: Int) -> String {
        let operation = operations[row]

        let firstAccount = accounts.first { (account) -> Bool in
            account.id == operation.firstAccountId
        }

        let secondAccount = accounts.first { (account) -> Bool in
            account.id == operation.secondAccountId
        }

        let firstAccountDescription = firstAccount?.description ?? ""
        let secondAccountDescription = secondAccount?.description ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd.MM.yyyy 'в' HH:mm"
        let date = dateFormatter.string(from: operation.date)

        guard let operationType = OperationModel.types.item(at: operation.operationTypeId) else
        {
            return ""
        }

        switch operationType {
        case .income:
            return "\(firstAccountDescription)\n\(operation.comment)\n\(date)"
        case .outgo:
            return "\(firstAccountDescription)\n\(operation.comment)\n\(date)"
        case .transfer:
            return "\(firstAccountDescription) → \(secondAccountDescription)\n\(operation.comment)\n\(date)"
        }
    }
    
    func getSum(for row: Int) -> String {
        let operation = operations[row]
        let sum = "\(operation.sum) ₽"

        guard let operationType = OperationModel.types.item(at: operation.operationTypeId) else
        {
            return ""
        }

        switch operationType {
        case .income:
            return "+ \(sum)"
        case .outgo:
            return "- \(sum)"
        case .transfer:
            return sum
        }
    }

    func accountIdDidChanged(_ id: Int) {
        if id == accounts.count + 1 {
            router.pushNewAccountView()
            return
        }

        if id <= 0 {
            selectedAccountId = id
        } else {
            selectedAccountId = accounts[id - 1].id
        }

        presentOperations()

        self.view.setAccountsButtonTitle(self.dropDownOptions[id])
    }
    
    func operationTypeDidChanged(_ id: Int) {
        selectedOperationType = id - 1
        presentOperations()
    }

    func logout() {
        let yesHandler = { [weak self] in
            KeychainWrapper.standard.removeObject(forKey: "userToken")
            self?.router.popToRootView()
        }

        self.view.showAlert(with: "Вв уверены, что хотите выйти?", yesHandler: yesHandler, cancelHandler: nil)
    }
    
    private func presentOperations() {
        let accountId = selectedAccountId == 0 ? nil : selectedAccountId
        let onSuccess: ([OperationModel]) -> () = { [weak self] (operations) in
            self?.operations = operations
            self?.view.updateOperations()
        }

        guard let operationType = OperationModel.types.item(at: selectedOperationType) else
        {
            interactor.getAllOperations(
                accountId: accountId,
                onSuccess: onSuccess,
                onFailure: {})
            return
        }

        switch operationType {
        case .income:
            interactor.getIncomes(
                accountId: accountId,
                onSuccess: onSuccess,
                onFailure: {})
        case .outgo:
            interactor.getOutgoes(
                accountId: accountId,
                onSuccess: onSuccess,
                onFailure: {})
        case .transfer:
            interactor.getTransfers(
                accountId: accountId,
                onSuccess: onSuccess,
                onFailure: {})
        }

    }

    private func configureAccounts() {
        let onSuccess: ([AccountModel]) -> () = { [weak self] (accounts) in
            self?.accounts = accounts
            
            self?.dropDownOptions = ["Все счета"]
            
            let accountsNames = accounts.map { (account) -> String in
                return "\(account.description) - \(account.sum) ₽"
            }
            
            self?.dropDownOptions.append(contentsOf: accountsNames)
            
            self?.dropDownOptions.append("Новый счет")
            self?.view.setAccountsConfiguration(self?.dropDownOptions ?? [])
            self?.view.allowNewOperation()
            self?.presentSum()
        }
        
        interactor.getAllAccounts(onSuccess: onSuccess, onFailure: {})
    }
    
    private func presentSum() {
        let sum = accounts.reduce(0) { (res, acc) -> Int in
            res + acc.sum
        }
        view.updateSum(value: "\(sum) ₽")
    }

    func operationsButtonPressed() {
        self.view.setHidesOperationsButton(true)
    }
}
