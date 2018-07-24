class AccountsPresenter {
    
    unowned let view: AccountsViewProtocol 
    var interactor: AccountsInteractorProtocol!
    let router: AccountsRouterProtocol
    
    private var operations = [Operation]()
    private var accounts = [Account]()
    private var selectedAccountId = 0
    private var selectedOperationType = -1

    required init(view: AccountsViewController, router: AccountsRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - AccountsPresenterProtocol

extension AccountsPresenter: AccountsPresenterProtocol
{
    var operationsCount: Int {
        get {
            return operations.count
        }
    }
    
    func prepareView() {
        configureAccounts()
        presentOperations()
    }
    
    func configureOperationTypesView() {
        let onIncomePressed = { [weak self] in
            self?.router.pushNewOperationView(with: Operation.Types.income, accounts: self?.accounts ?? [])
        }

        let onOutgoPressed = { [weak self] in
            self?.router.pushNewOperationView(with: Operation.Types.outgo, accounts: self?.accounts ?? [])
        }
        
        let onTransferPressed = { [weak self] in
            self?.router.pushNewOperationView(with: Operation.Types.transfer, accounts: self?.accounts ?? [])
        }

        view.setOperationTypesConfiguration(onIncomePressed: onIncomePressed, onOutgoPressed: onOutgoPressed, onTransferPressed: onTransferPressed)
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

        switch operation.operationTypeId {
        case Operation.Types.income.rawValue:
            return "Доход\n\(firstAccountDescription)\n\(operation.comment)"
        case Operation.Types.outgo.rawValue:
            return "Расход\n\(firstAccountDescription)\n\(operation.comment)"
        case Operation.Types.transfer.rawValue:
            return "Перевод\n\(firstAccountDescription) → \(secondAccountDescription)\n\(operation.comment)"
        default:
            return ""
        }
    }
    
    func getSum(for row: Int) -> String {
        let operation = operations[row]
        let sum = "\(operation.sum) ₽"
        
        switch operation.operationTypeId {
        case Operation.Types.income.rawValue:
            return "+ \(sum)"
        case Operation.Types.outgo.rawValue:
            return "- \(sum)"
        default:
            return sum
        }
    }

    func accountIdDidChanged(_ id: Int) {
        if id == accounts.count + 1 {
            // !! new account
            return
        }
        selectedAccountId = id
        presentOperations()
    }
    
    func operationTypeDidChanged(_ id: Int) {
        selectedOperationType = id - 1
        presentOperations()
    }
    
    private func presentOperations() {
        interactor.getOperations(operationType: operationTypeToString(), account: accountIdToString(), onSuccess: { (operations) in
            self.operations = operations
            self.view.updateOperations()
        }) {}
    }
    
   private func operationTypeToString() -> String {
        switch selectedOperationType {
        case Operation.Types.income.rawValue:
            return "/income"
        case Operation.Types.outgo.rawValue:
            return "/outgo"
        case Operation.Types.transfer.rawValue:
            return "/transfer"
        default:
            return ""
        }
    }
    
    private func accountIdToString() -> String {
        if selectedAccountId > 0 {
            let id = accounts[selectedAccountId - 1].id
            return "/\(id)"
        }
        return ""
    }
    
    private func configureAccounts() {
        let onSuccess: ([Account]) -> () = { (accounts) in
            self.accounts = accounts
            
            var dropDownOptions = ["Все счета"]
            
            let accountsNames = accounts.map { (account) -> String in
                "\(account.description)"
            }
            
            dropDownOptions.append(contentsOf: accountsNames)
            
            dropDownOptions.append("Новый счет")
            
            let title = dropDownOptions[self.selectedAccountId]

            self.view.setAccountsConfiguration(with: title, dropDownOptions: dropDownOptions)
            self.presentSum()
        }
        
        interactor.getAllAccounts(onSuccess: onSuccess, onFailure: {})
    }
    
    private func presentSum() {
        let sum = accounts.reduce(0) { (res, acc) -> Int in
            res + acc.sum
        }
        view.updateSum(value: "\(sum) ₽")
    }
}
