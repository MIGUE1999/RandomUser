import Foundation
@testable import RandomUser

final class RandomUsersServiceMock: RandomUsersServiceContract {
    var mockData: Data?
    var mockError: Error?

    func fetchRandomUsers(page: Int) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }
}
