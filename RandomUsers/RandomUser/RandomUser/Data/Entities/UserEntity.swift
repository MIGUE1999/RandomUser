import Foundation

struct UserEntity: Codable, Hashable {
    let gender: String
    let name: NameEntity
    let location: LocationEntity
    let email: String
    let registered: RegisteredEntity
    let phone: String
    let picture: PictureEntity
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(email.lowercased())
    }
    
    static func == (lhs: UserEntity, rhs: UserEntity) -> Bool {
        return lhs.email.lowercased() == rhs.email.lowercased()
    }
}
