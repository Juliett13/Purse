import Foundation

class AccountsInteractor: Queryable {
    unowned var presenter: AccountsPresenterProtocol
    
    init(presenter :AccountsPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - AccountsInteractorProtocol

extension AccountsInteractor: AccountsInteractorProtocol  {
    
    func createAccount(credentials: [String : Any], onSuccess: @escaping (NSArray) -> (), onFailure: @escaping () -> ()) {
        //
    }
    
    func getOperations(operationType: String, account: String, onSuccess: @escaping ([Operation]) -> (), onFailure: @escaping () -> ()) {
        let headers = [
            "Authorization": "Bearer \(token ?? "")"
        ]

        let url = "operation" + operationType + account
        
        // REVIEW: Why are you using NSDictionary and NSArray?
        let onSuccess: (Any) -> () = { any in
            if let array = any as? NSArray {
                let operations = array.map({ (dict) -> Operation? in
                    if let d = dict as? NSDictionary,
                        // Use subscript d["id"]
                     
                        let id = d["id"] as? Int,
                        let operationTypeId = d["operationTypeId"] as? Int,
                        // DON'T use value(forKey:), this is very dangerous. This way you are requesting value of variable named "sum", not object in dict with key "sum". Also, check out Codable
                        let sum = d.value(forKey: "sum") as? Int,
                        let firstAccountId = d.value(forKey: "firstAccountId") as? Int,
                        let comment = d.value(forKey: "comment") as? String
                        //                                let date = d.value(forKey: "date") as? Date
                    {
                        let secondAccountId = d.value(forKey: "secondAccountId") as? Int
                        let op = Operation(id: id, operationTypeId: operationTypeId, sum: sum, firstAccountId: firstAccountId, secondAccountId: secondAccountId, comment: comment)
                        return op
                    }
                    return nil
                })
                let nonNilOperations = operations.compactMap { $0 }
                onSuccess(nonNilOperations)
            }
        }
        
        get(url: url, headers: headers, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func getAllAccounts(onSuccess: @escaping ([Account]) -> (), onFailure: @escaping () -> ()) {
        let headers = [
            "Authorization": "Bearer \(token ?? "")"
        ]
        let url = "account/"
        
        let onSuccess: (Any) -> () = { any in
            if let array = any as? NSArray {
                let accounts = array.map({ (dict) -> Account? in
                    if let d = dict as? NSDictionary,
                        let id = d.value(forKey: "id") as? Int,
                        let sum = d.value(forKey: "sum") as? Int,
                        let userId = d.value(forKey: "userId") as? Int,
                        let description = d.value(forKey: "description") as? String
                    {
                        let account = Account(id: id, sum: sum, userId: userId, description: description)
                        return account
                    }
                    return nil
                })
                let nonNilAccounts = accounts.compactMap { $0 }
                onSuccess(nonNilAccounts)
            }
        }
        
        get(url: url, headers: headers, onSuccess: onSuccess, onFailure: onFailure)
    }
}

