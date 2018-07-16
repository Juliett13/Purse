struct User {
    var id: Int
    var username: String
    var token: String

    init(id: Int, username: String, token: String) {
        self.id = id
        self.username = username
        self.token = token
    }
}
