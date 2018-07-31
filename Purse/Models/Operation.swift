import Foundation

struct OperationModel: Codable {
    enum Types: Int {
        case income = 0
        case outgo = 1
        case transfer = 2
    }

    static let types: [Types] = [.income, .outgo, .transfer]

    var id: Int
    var operationTypeId: Int
    var sum: Int                
    var firstAccountId: Int
    var secondAccountId: Int?
    var date: Date
    var comment: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.operationTypeId = try container.decode(Int.self, forKey: .operationTypeId)
        self.sum = try container.decode(Int.self, forKey: .sum)
        self.firstAccountId = try container.decode(Int.self, forKey: .firstAccountId)
        self.secondAccountId = try? container.decode(Int.self, forKey: .secondAccountId)
        self.comment = try container.decode(String.self, forKey: .comment)

        let stringDate = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let date = dateFormatter.date(from: stringDate)

        self.date = date ?? Date()
    }
}
