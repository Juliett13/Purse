import Foundation

struct Operation {
    enum operations: Int {
        case income = 0
        case outgo = 1
        case transfer = 2
    }

    var id: Int
    var operationTypeId: Int
    var sum: Int                //
    var firstAccountId: Int
    var secondAccountId: Int 
    var date: Date
    var comment: String
    
    init(id: Int, operationTypeId: Int, sum: Int, firstAccountId: Int, secondAccountId: Int, comment: String) {
        self.id = id
        self.operationTypeId = operationTypeId
        self.sum = sum
        self.firstAccountId = firstAccountId
        self.secondAccountId = secondAccountId
        date = Date()
        self.comment = comment
    }
}
