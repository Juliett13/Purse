import Foundation
import PromiseKit

class NewOperationInteractor {
    unowned var presenter: NewOperationPresenter

    init(presenter: NewOperationPresenter) {
        self.presenter = presenter
    }
}

// MARK: - NewOperationInteractorProtocol

extension NewOperationInteractor: NewOperationInteractorProtocol {
    func createIncome(dto: IncomeOutgoDto,
                      onSuccess: @escaping () -> (),
                      onFailure: @escaping () -> ()) {

        let request = Request.Operation.Income.Post(
            sum: dto.sum,
            accountId: dto.accountId,
            comment: dto.comment)

        request.send().done { _ in
            onSuccess()
            }.catch { _ in
                onFailure()
        }
    }

    func createOutgo(dto: IncomeOutgoDto,
                     onSuccess: @escaping () -> (),
                     onFailure: @escaping () -> ()) {

        let request = Request.Operation.Outgo.Post(
            sum: dto.sum,
            accountId: dto.accountId,
            comment: dto.comment)

        request.send().done { _ in
            onSuccess()
            }.catch { _ in
                onFailure()
        }
    }

    func createTransfer(dto: TransferDto,
                        onSuccess: @escaping () -> (),
                        onFailure: @escaping () -> ()) {

        let request = Request.Operation.Transfer.Post(
            sum: dto.sum,
            firstAccountId: dto.firstAccountId,
            secondAccountId: dto.secondAccountId,
            comment: dto.comment)

        request.send().done { _ in
            onSuccess()
            }.catch { _ in
                onFailure()
        }
    }
}

