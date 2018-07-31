// MARK: - Login

struct LoginDto {
    var login: String
    var password: String
}

// MARK: - Income/Outgo

struct IncomeOutgoDto {
    var sum: Int
    var comment: String
    var accountId: Int
}

// MARK: - Transfer

struct TransferDto {
    var sum: Int
    var comment: String
    var firstAccountId: Int
    var secondAccountId: Int
}

// MARK: - Account

struct AccountDto {
    var sum: Int
    var description: String
}

