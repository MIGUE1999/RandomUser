@testable import RandomUser

final class RandomUsersRepositoryMock: RandomUsersRepositoryContract {
    var deletedIndex: Int?
    var getRandomUsersCalledWithPage: Int?
    var usersToReturn: [RandomUsersModel] = []
    var errorToThrow: Error?
    
    func getRandomUsers(page: Int) async throws -> [RandomUsersModel] {
        getRandomUsersCalledWithPage = page
        
        if let error = errorToThrow {
            throw error
        }
        
        return usersToReturn
    }
    
    func delete(at index: Int) {
        deletedIndex = index
    }
}
