import Foundation

class NewAccountPresenter {

    unowned let view: NewAccountViewProtocol
    var interactor: NewAccountInteractorProtocol!
    let router: NewAccountRouterProtocol

    enum Sections: Int {
        case sum
        case name
    }

    let sections: [Sections] = [.sum, .name]

    var sum = ""
    var name = ""

    init(view: NewAccountViewProtocol, router: NewAccountRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - NewAccountPresenterProtocol

extension NewAccountPresenter: NewAccountPresenterProtocol {
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

        case .name:
            guard let textRange = Range(range, in: name) else
            {
                return false
            }
            name = name.replacingCharacters(in: textRange, with: string)
        }

        return true
    }

    func accountNameTag() -> Int {
        guard let tag = sections.index(of: .name) else {
            return -1
        }
        return tag
    }

    func accountBalanceTag() -> Int {
        guard let tag = sections.index(of: .sum) else {
            return -1
        }
        return tag
    }

    func savePressed() {
        if self.sum.isEmpty || name.isEmpty {
            view.showAlert(
                with: "Заполните все поля!",
                handler: nil)
            return
        }

        let onSuccess: () -> () = { [weak self] in
            let handler = { [weak self] in
                self?.router.popView()
            }

            self?.view.showAlert(
                with: "Счет успешно создан.",
                handler: handler)
        }

        let onFailure: () -> ()  = { [weak self] in
            self?.view.showAlert(
                with: "Произошла ошибка при создании счета. Пожалуйста, проверьте все поля.",
                handler: nil)
        }

        let sum = Int(self.sum) ?? 0

        let dto = AccountDto(sum: sum, description: name)

        interactor.createAccount(
            account: dto,
            onSuccess: onSuccess,
            onFailure: onFailure)
    }
}
