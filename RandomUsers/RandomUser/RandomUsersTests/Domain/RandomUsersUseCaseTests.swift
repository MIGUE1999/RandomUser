import XCTest
@testable import RandomUser

final class GetRandomUsersUseCaseTests: XCTestCase {
    var sut: GetRandomUsersUseCase!
    var mockRepository: RandomUsersRepositoryMock!

    override func setUp() {
        super.setUp()
        mockRepository = RandomUsersRepositoryMock()
        sut = GetRandomUsersUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_run_callsRepositoryWithCurrentPage_andIncrementsPage() async throws {
        // Given
        let expectedUsers = [RandomUsersModel.dummyInsatance()]
        mockRepository.usersToReturn = expectedUsers

        // When
        let firstCallUsers = try await sut.run()

        // Then
        XCTAssertEqual(mockRepository.getRandomUsersCalledWithPage, 1)
        XCTAssertEqual(firstCallUsers.count, expectedUsers.count)
        XCTAssertEqual(firstCallUsers[0].email, expectedUsers[0].email)

        let _ = try await sut.run()

        XCTAssertEqual(mockRepository.getRandomUsersCalledWithPage, 2)
    }

    func test_run_throwsError_whenRepositoryThrows() async {
        // Given
        enum TestError: Error { case sample }
        mockRepository.errorToThrow = TestError.sample

        // When / Then
        do {
            _ = try await sut.run()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
