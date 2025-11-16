struct UserModel: Decodable {
    let id: Int
    let email: String
    let role: String
    let passwordHash: String 
}
