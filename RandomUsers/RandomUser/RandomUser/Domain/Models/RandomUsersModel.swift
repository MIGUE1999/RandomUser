struct RandomUsersModel: Hashable {
    let gender: String
        let name: String
        let surname: String
        let fullName: String
        let email: String
        let phone: String
        let pictureURL: String
        
        let street: String
        let city: String
        let state: String
        
        let registeredDate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(email)
    }
    
    static func == (lhs: RandomUsersModel, rhs: RandomUsersModel) -> Bool {
        return lhs.email == rhs.email
    }
}
