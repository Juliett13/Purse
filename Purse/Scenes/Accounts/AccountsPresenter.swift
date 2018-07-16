protocol AccountsPresenterProtocol {
    init(view: AccountsViewController)
    var operationsCount: Int { get }
    func configureAccountsButton()
    func configureOperationTypesView()
    func configure(cell: OperationTableViewCellInfoDisplayProtocol,for row: Int)
}

class AccountsPresenter: AccountsPresenterProtocol {
    
    unowned let view: AccountsViewProtocol 
    private var operations = [Operation]()
    var operationsCount: Int {
        get {
            return operations.count
        }
    }
    
    required init(view: AccountsViewController) {
        self.view = view
//        self.operations = 
    }

    func configureOperationTypesView() {
        let onIncomePressed = { [weak self] in
            self?.pushNewOperationVC(with: Operation.operations.income)
        }

        let onOutgoPressed = { [weak self] in
            self?.pushNewOperationVC(with: Operation.operations.outgo)
        }
        
        let onTransferPressed = { [weak self] in
            self?.pushNewOperationVC(with: Operation.operations.transfer)
        }

        view.setOperationTypesConfiguration(onIncomePressed: onIncomePressed, onOutgoPressed: onOutgoPressed, onTransferPressed: onTransferPressed)
    }
    
    func pushNewOperationVC(with operationType: Operation.operations) {
        let targetVC = self.view.instantiateViewController(with: NewOperationViewController.reuseId) as! NewOperationViewController
        
        let presenter = NewOperationPresenter(view: targetVC, operationType: operationType.rawValue)
        targetVC.presenter = presenter
        self.view.push(targetVC)
    }
    
    func configureAccountsButton() {
        let title = "All accounts" //
        let dropDownOptions = ["All accounts", "Acc1", "Acc2", "Acc3"] //
        view.setAccountsButtonConfiguration(with: title, dropDownOptions: dropDownOptions)
    }
        
    func configure(cell: OperationTableViewCellInfoDisplayProtocol,for row: Int) {
        let operation = operations[row]
        
//        cell.display(info: )
        cell.display(sum: operation.sum)
    }
}
