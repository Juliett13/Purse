import Foundation

class NewOperationPresenter {

    var operationType: OperationModel.Types

    unowned let view: NewOperationViewProtocol
    var interactor: NewOperationInteractorProtocol! 
    let router: NewOperationRouterProtocol
    
    let accounts: [AccountModel]
    var firstAccount = 0
    var secondAccount = 0
    var sum = ""
    var comment = ""
    
    enum Sections: Int {
        case firstAccount
        case secondAccount
        case sum
        case comment
    }

    let sections: [Sections] = [.firstAccount, .secondAccount, .sum, .comment]
    
    init(view: NewOperationViewProtocol,
         router: NewOperationRouterProtocol,
         operationType: Int,
         accounts: [AccountModel]) {

        if let operationType = OperationModel.types.item(at: operationType) {
            self.operationType = operationType
        } else {
            self.operationType = .income
        }

        self.view = view
        self.router = router
        self.accounts = accounts
    }
}

// MARK: - NewOperationPresenterProtocol

extension NewOperationPresenter: NewOperationPresenterProtocol
{
    var accountsCount: Int {
        return accounts.count
    }

    var allowTransfer: Bool {
        return accounts.count > 1
    }

    var firstAccountTag: Int {
        guard let tag = sections.index(of: .firstAccount) else {
            return -1
        }
        return tag
    }

    var secondAccountTag: Int {
        guard let tag = sections.index(of: .secondAccount) else {
            return -1
        }
        return tag
    }

    var sumTag: Int {
        guard let tag = sections.index(of: .sum) else {
            return -1
        }
        return tag
    }

    var commentTag: Int {
        guard let tag = sections.index(of: .comment) else {
            return -1
        }
        return tag
    }

    func shouldChangeCharacters(in range: NSRange,
                                replacementString string: String,
                                tag: Int) -> Bool {

        guard let cell = self.sections.item(at: tag) else
        {
            return false
        }

        switch cell
        {
        case .sum:
            guard let textRange = Range(range, in: sum) else
            {
                return false
            }
            sum = sum.replacingCharacters(in: textRange, with: string)

        case .comment:
            guard let textRange = Range(range, in: comment) else
            {
                return false
            }
            comment = comment.replacingCharacters(in: textRange, with: string)
        case .firstAccount:
            return false
        case .secondAccount:
            return false
        }
        
        return true
    }
    
    func didSelectAccount(tag: Int, row: Int) {

        guard let cell = self.sections.item(at: tag) else
        {
            return
        }

        switch cell {
        case .firstAccount:
            firstAccount = row
        case .secondAccount:
            secondAccount = row
        case .sum:
            return
        case .comment:
            return
        }
    }

    func accountName(for row: Int) -> String {
        let account = accounts[row]
        return "\(account.description) \(account.sum) ₽"
    }

    func operationTypeChanged(id: Int) {
        guard let newOperationType = OperationModel.types.item(at: id) else {
            return
        }

        let previousTypeIsTransfer = operationType == .transfer
        let selectedTypeIsTransfer = newOperationType == .transfer

        if previousTypeIsTransfer {
            transferDidDeselected()
        } else if selectedTypeIsTransfer {
            transferDidSelected()
        }

        operationType = newOperationType
    }
    
    func prepareView() {
        let selectedTypeIsNotTransfer = operationType != .transfer
        if selectedTypeIsNotTransfer {
            transferDidDeselected()
        }
    }

    private func transferDidSelected() {
        view.setConfiguration(
            firstAccountLabelText: "Счет списания",
            secondAccountLabelText: "Счет пополнения",
            secondAccountIsHidden: false)
    }
    
    private func transferDidDeselected() {
        view.setConfiguration(
            firstAccountLabelText: "Счет",
            secondAccountLabelText: "",
            secondAccountIsHidden: true)
    }
    
    func savePressed() {
        if self.sum.isEmpty || comment.isEmpty {
            view.showAlert(
                with: "Заполните все поля!",
                handler: nil)
            return
        }

        let sum = Int(self.sum) ?? 0
        let firstAccount = accounts[self.firstAccount]

        let enoughFunds = operationType == .income || sum <= firstAccount.sum

        if !enoughFunds {
            view.showAlert(
                with: "Недостаточно средств на счете!",
                handler: nil)
            return
        }


        let onSuccess: () -> () = { [weak self] in
            let handler = { [weak self] in
                self?.router.popView()
            }
            
            self?.view.showAlert(
                with: "Оперция успешно создана.",
                handler: handler)
        }

        let onFailure: () -> ()  = { [weak self] in
            self?.view.showAlert(
                with: "Произошла ошибка при создании операции. Пожалуйста, проверьте все поля.",
                handler: nil)
        }

        switch operationType {
        case .income:
            let dto = IncomeOutgoDto(
                sum: sum,
                comment: comment,
                accountId: firstAccount.id)
            interactor.createIncome(
                dto: dto,
                onSuccess: onSuccess,
                onFailure: onFailure)

        case .outgo:
            let dto = IncomeOutgoDto(
                sum: sum,
                comment: comment,
                accountId: firstAccount.id)
            interactor.createOutgo(
                dto: dto,
                onSuccess: onSuccess,
                onFailure: onFailure)

        case .transfer:
            let secondId = accounts[secondAccount].id
            let dto = TransferDto(
                sum: sum,
                comment: comment,
                firstAccountId: firstAccount.id,
                secondAccountId: secondId)
            interactor.createTransfer(
                dto: dto,
                onSuccess: onSuccess,
                onFailure: onFailure)
        }
    }
}
