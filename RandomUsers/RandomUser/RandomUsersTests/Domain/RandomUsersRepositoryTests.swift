import XCTest
@testable import RandomUser

final class RandomUsersRepositoryTests: XCTestCase {
    var sut: RandomUsersRepository!
    var remoteDataSource: RandomUsersRemoteDataSourceMock!
    var localDataSource: RandomUsersLocalDataSourceMock!
    var mapper: RandomUsersMapperMock!

    override func setUp() {
        super.setUp()
        remoteDataSource = RandomUsersRemoteDataSourceMock()
        localDataSource = RandomUsersLocalDataSourceMock()
        mapper = RandomUsersMapperMock()
        sut = RandomUsersRepository(remoteDataSource: remoteDataSource,
                                    localDataSource: localDataSource,
                                    mapper: mapper)
    }

    override func tearDown() {
        sut = nil
        remoteDataSource = nil
        localDataSource = nil
        mapper = nil
        super.tearDown()
    }

    func test_getRandomUsers_returnsMappedUsers() async throws {
        let userEntity = UserEntity.dummyInsatance()
        remoteDataSource.usersToReturn = RandomUsersEntity(results: [userEntity])
        localDataSource.savedUsers = []
        localDataSource.blockedEmails = []
        let expectedModels = [RandomUsersModel.dummyInsatance()]
        mapper.mappedModels = expectedModels

        let models = try await sut.getRandomUsers(page: 1)

        // Assert
        XCTAssertEqual(models.count, expectedModels.count)
        XCTAssertEqual(models.first?.email, expectedModels.first?.email)
    }

    func test_getRandomUsers_filtersBlockedEmails() async throws {
        let blockedEmail = "blocked@example.com"
        localDataSource.blockedEmails = [blockedEmail]

        let blockedUser = UserEntity.dummyInsatance()

        localDataSource.savedUsers = [blockedUser]
        remoteDataSource.usersToReturn = RandomUsersEntity(results: [blockedUser])
        mapper.mappedModels = []

        let models = try await sut.getRandomUsers(page: 1)

        // Assert
        XCTAssertTrue(models.isEmpty)
    }

    func test_delete_insertsEmailIntoBlockedAndSaves() {
        let user = UserEntity.dummyInsatance()
        localDataSource.savedUsers = [user]
        localDataSource.blockedEmails = []

        sut.delete(at: 0)

        // Assert
        XCTAssertTrue(localDataSource.blockedEmails.contains("john.doe@example.com"))
        XCTAssertTrue(localDataSource.savedUsers.isEmpty)
    }

    func test_delete_invalidIndex_doesNothing() {
        localDataSource.savedUsers = []
        localDataSource.blockedEmails = []

        sut.delete(at: 5)

        XCTAssertTrue(localDataSource.blockedEmails.isEmpty)
        XCTAssertTrue(localDataSource.savedUsers.isEmpty)
    }
}
