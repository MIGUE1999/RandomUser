import Foundation

@testable import RandomUser

final class GetRandomUsersUseCaseMock: GetRandomUsersUseCaseContract {
    var usersToReturn: [RandomUsersModel] = []
    var shouldThrow = false

    func run() async throws -> [RandomUsersModel] {
        if shouldThrow {
            throw NSError(domain: "Test", code: 1, userInfo: nil)
        }
        return usersToReturn
    }
}
