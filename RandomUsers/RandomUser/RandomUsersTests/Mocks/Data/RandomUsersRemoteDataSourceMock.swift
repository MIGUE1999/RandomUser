@testable import RandomUser

final class RandomUsersRemoteDataSourceMock: RandomUsersRemoteDataSourceContract {
    var usersToReturn: RandomUsersEntity?
    var errorToThrow: Error?

    func getRandomUsers(page: Int) async throws -> RandomUsersEntity {
        if let error = errorToThrow {
            throw error
        }
        return usersToReturn ?? RandomUsersEntity(results: [])
    }
}
