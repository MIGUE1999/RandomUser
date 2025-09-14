import Foundation

@testable import RandomUser

final class RandomUsersLocalDataSourceMock: RandomUserLocalDataSourceContract {
    var savedUsers: [UserEntity] = []
    var blockedEmails: Set<String> = []

    func save<T>(_ items: [T]) throws where T : Decodable, T : Encodable {
        if let users = items as? [UserEntity] {
            savedUsers = users
        }
    }

    func load<T>(as type: T.Type) throws -> T where T : Decodable, T : Encodable {
        if type == [UserEntity].self {
            return savedUsers as! T
        }
        throw NSError(domain: "MockLocalDataSource", code: 1, userInfo: nil)
    }

    func loadBlockedEmails() -> Set<String> {
        return blockedEmails
    }

    func saveBlockedEmails(_ emails: Set<String>) {
        blockedEmails = emails
    }
}

