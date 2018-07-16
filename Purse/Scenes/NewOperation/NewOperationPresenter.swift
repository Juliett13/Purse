protocol NewOperationPresenterProtocol {
    var operationType: Int { get set }
    func operationTypeChanged(id: Int)
    func prepareView() 
}

class NewOperationPresenter: NewOperationPresenterProtocol {

    var operationType: Int

    unowned let view: NewOperationViewProtocol

    init(view: NewOperationViewController, operationType: Int) {
        self.view = view
        self.operationType = operationType
    }
    
    func operationTypeChanged(id: Int) {
        if (operationType == Operation.operations.transfer.rawValue) {
            transferDidDeselected()
        } else if (id == Operation.operations.transfer.rawValue) {
            transferDidSelected()
        }
        operationType = id
    }
    
    private func transferDidSelected() {
        view.setConfiguration(firstAccountLabelText: "Счет списания", secondAccountLabelText: "Счет пополнения", secondAccountIsHidden: false)
    }
    
    private func transferDidDeselected() {
        view.setConfiguration(firstAccountLabelText: "Счет", secondAccountLabelText: "", secondAccountIsHidden: true)
    }
    
    func prepareView() {
        if (operationType != Operation.operations.transfer.rawValue) {
            transferDidDeselected()
        }
    }
}
