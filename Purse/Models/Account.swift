struct Account {
    var id: Int
    var sum: Int // 
    var userId: Int
    var description: String
    
    init(id: Int, sum: Int, userId: Int, description: String) {
        self.id = id
        self.sum = sum
        self.userId = userId
        self.description = description
    }
}
