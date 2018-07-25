import Foundation

// MARK: - View

protocol NewOperationViewProtocol: class {
    func setConfiguration(firstAccountLabelText: String, secondAccountLabelText: String, secondAccountIsHidden: Bool)
    func showAlert(with message: String, handler: (() -> ()?)?) 
}

// MARK: - Presenter

protocol NewOperationPresenterProtocol {
    // REVIEW: General info - The tricky thing about variables in protocols is when you implement protocol, you have no way to know, if variable is get-only.
    var operationType: Int { get set }
    var accountsCount: Int { get }
    var firstAccountTag: Int { get }
    var secondAccountTag: Int { get }
    var sumTag: Int { get }
    var commentTag: Int { get }
    
    func operationTypeChanged(id: Int)
    func prepareView()
    func accountName(for row: Int) -> String
    func didSelectAccount(tag: Int, row: Int)
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, tag: Int) -> Bool
    // REVIEW: Name user actions more clearly like "savePressed"
    func save()
}

// MARK: - Interactor

// REVIEW: Example of data passing to Interactor

struct IncomeDto
{
    var sum: Int
    var comment: String
    var accountId: String
}

protocol NewOperationInteractorProtocol: class {
    // REVIEW: Use DTOs like structs or classes, not dictionarires. It is very easy to mistype.
    // Presenter wants a job done. It provides interactor with data and waits for response. It doesn't care about how interactor is going to process a task. It doesn't know about restApi, database or any other services.
    func createIncome(dto: IncomeDto, onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
    
    func createIncome(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
    func createOutgo(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
    func createTransfer(credentials: [String : Any], headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
}

extension NewOperationInteractorProtocol
{
    func createIncome(dto: IncomeDto, onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
    {
        
    }
}

// MARK: - Router

protocol NewOperationRouterProtocol {
    func popView()
}

