import Foundation

class NewOperationPresenter {

    var operationType: Int

    unowned let view: NewOperationViewProtocol
    var interactor: NewOperationInteractorProtocol! 
    let router: NewOperationRouterProtocol
    
    let accounts: [Account]
    var firstAccount = 0
    var secondAccount = 0
    var sum = ""
    var comment = ""
    
    enum Field: Int {
        case firstAccount
        case secondAccount
        case sum
        case comment
    }
    
    init(view: NewOperationViewController, router: NewOperationRouterProtocol, operationType: Int, accounts: [Account]) {
        self.view = view
        self.operationType = operationType
        self.router = router
        self.accounts = accounts
    }
}

// MARK: - NewOperationPresenterProtocol

extension NewOperationPresenter: NewOperationPresenterProtocol
{
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, tag: Int) -> Bool {
        
        switch tag {
        case Field.sum.rawValue:
            guard let textRange = Range(range, in: sum) else
            {
                return false
            }
            sum = sum.replacingCharacters(in: textRange, with: string)
            
        case Field.comment.rawValue:
            guard let textRange = Range(range, in: comment) else
            {
                return false
            }
            comment = comment.replacingCharacters(in: textRange, with: string)
            
        default:
            return false
        }
        
        return true
    }
    
    func didSelectAccount(tag: Int, row: Int) {
        switch tag {
        case Field.firstAccount.rawValue:
            firstAccount = row
        case Field.secondAccount.rawValue:
            secondAccount = row
        default:
            return
        }
    }
    
    var firstAccountTag: Int {
        return Field.firstAccount.rawValue
    }
    
    var secondAccountTag: Int {
        return Field.secondAccount.rawValue
    }
    
    var sumTag: Int {
        return Field.sum.rawValue
    }
    
    var commentTag: Int {
        return Field.comment.rawValue
    }

    func accountName(for row: Int) -> String {
        return "\(accounts[row].description)"
    }
    
    var accountsCount: Int {
        return accounts.count
    }
    
    func operationTypeChanged(id: Int) {
        if (operationType == Operation.Types.transfer.rawValue) {
            transferDidDeselected()
        } else if (id == Operation.Types.transfer.rawValue) {
            transferDidSelected()
        }
        operationType = id
    }
    
    func prepareView() {
        if (operationType != Operation.Types.transfer.rawValue) {
            transferDidDeselected()
        }
    }

    private func transferDidSelected() {
        view.setConfiguration(firstAccountLabelText: "Счет списания", secondAccountLabelText: "Счет пополнения", secondAccountIsHidden: false)
    }
    
    private func transferDidDeselected() {
        view.setConfiguration(firstAccountLabelText: "Счет", secondAccountLabelText: "", secondAccountIsHidden: true)
    }
    
    func save() {
        if sum.isEmpty || comment.isEmpty {
            view.showAlert(with: "Заполните все поля!", handler: nil)
            return
        }

        
        let onSuccess: (Any) -> () = { _ in
            let handler = { [weak self] in
                self?.router.popView()
            }
            
            self.view.showAlert(with: "Оперция успешно создана.", handler: handler)
        }

        let onFailure = {
//            self.view.showAlert(with: "Произошла ошибка при создании операции. Пожалуйста, проверьте все поля.", handler: nil)
            let handler = { [weak self] in
                self?.router.popView()
            }

            self.view.showAlert(with: "Оперция успешно создана.", handler: handler) // !!

        }
        
        var credentials: [String: Any] = [
            "sum": Int(sum) ?? 0,
            "comment": comment
        ]

        let headers = [
            "Authorization": "Bearer \(token ?? "")"
        ]


        switch operationType {
        case Operation.Types.income.rawValue:
            credentials["accountId"] = accounts[firstAccount].id
            interactor.createIncome(credentials: credentials, headers: headers, onSuccess: onSuccess, onFailure: onFailure)
            
        case Operation.Types.outgo.rawValue:
            credentials["accountId"] = accounts[firstAccount].id
            interactor.createOutgo(credentials: credentials, headers: headers, onSuccess: onSuccess, onFailure: onFailure)
            
        case Operation.Types.transfer.rawValue:
            credentials["firstAccountId"] = accounts[firstAccount].id
            credentials["secondAccountId"] = accounts[secondAccount].id
            interactor.createTransfer(credentials: credentials, headers: headers, onSuccess: onSuccess, onFailure: onFailure)
            
        default:
            return
        }
    }
}
